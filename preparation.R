library(readxl)
library(data.table)
library(plotly)
library(stringr)
library(rsconnect)

source('mappings.R')
source('helpers.R')

DATA_PATH = "./data/"

################################################################################
#                                                                              #
#   Load and prepare voting data                                               #
#                                                                              #
################################################################################
###      Load data and transform                                             ###

DT = load_voting_data(DATA_PATH)
colnames(DT) <- c("VotingNumber","Session","Party", "Member", "Yes", "No", 
                  "Abstention", "Absent", "VotingMatter")

normalize_member_names(DT)

setkey(DT, VotingMatter, Party, Member)

################################################################################
###     Filter for member with high coverage                                 ###

ValidMember = DT[, .N, by=Member]
ValidMember = ValidMember[N > (0.975*max(N))]$Member
DT = DT[Member %in% ValidMember]

################################################################################
###      Correct for abstentions                                             ###
#   Since we don't really know the voting intent, we assume 0.5                #

DT$YesFloat = as.numeric(DT$Yes)
DT[Abstention == 1, YesFloat := 0.5]

################################################################################
###      Correct for absent                                                  ###
#   We assume that the member would have voted in party line.                  #

unique_voting_matter = unique(DT$VotingMatter)
for (matter in unique_voting_matter){
  party_mean = DT[VotingMatter == matter & Absent==0, 
                  .(MeanValue = mean(YesFloat)), by= Party]
  for (party in party_mean$Party){
    DT[Party == party & Absent==1 & VotingMatter == matter, 
       YesFloat := party_mean[Party == party]$MeanValue]
  }
}

saveRDS(DT, "./r_data/voting_dt.RDS")

################################################################################
#                                                                              #
#                 Preparation of some maybe interesting plots                  #
#                                                                              #
################################################################################
###      Number of absent votes                                             #### 

AbsenteeVotes = unique(DT[, 
                          .("AbsentSum" = sum(Absent), "Party"=Party), 
                          by = Member])
outlier  = boxplot(AbsenteeVotes$AbsentSum,plot = FALSE)
OutlierDT = AbsenteeVotes[AbsenteeVotes$Absent > outlier$stats[5,1] | 
                            AbsenteeVotes$Absent < outlier$stats[1,1],]
AbsenteeVotes = AbsenteeVotes[! Member %in% unique(OutlierDT$Member)]

saveRDS(AbsenteeVotes, "./r_data/absentee_vote_dt.RDS")

absentee_vote_plot = 
  plot_ly(AbsenteeVotes, y=~AbsentSum, x=1, type = "box") %>%
  add_markers(data = OutlierDT, text = OutlierDT$Member) %>% 
  layout(showlegend = FALSE)

################################################################################
###      Ranking of absentee outlier                                         ###

OutlierDT = OutlierDT[order(-AbsentSum)]
OutlierDT = OutlierDT[!duplicated(Member)]
OutlierDT$Member = factor(OutlierDT$Member, 
                          levels = c(as.character(OutlierDT$Member)))

saveRDS(OutlierDT, "./r_data/absentee_outlier_dt.RDS")

absentee_outlier_plot = 
  plot_ly(OutlierDT, y=~AbsentSum, 
          colors = get_color_palette(unique(OutlierDT$Party)),
          x=~Member, type = "bar", color= ~Party)

################################################################################
###      Voting variance by party                                            ###
#   One data point per party per voting                                        #

AbsVariance = DT[, .(Mean = mean(YesFloat), Variance = sd(YesFloat)), 
                 by = .(Party, VotingMatter)]

saveRDS(AbsVariance, "./r_data/party_variance_dt.RDS")

party_variance_boxplot = 
  plot_ly(AbsVariance, y = ~Variance, color = ~Party, 
          colors = get_color_palette(unique(AbsVariance$Party)),
          type = "box", text = ~VotingMatter) %>%
  layout(title = 'Variance within votings by party')

################################################################################
###      Variance within a party                                             ###
#   One data point per party member                                            #

MemberVariance = merge(DT[, .(Party, Member, YesFloat, VotingMatter)], 
                     AbsVariance, by = c("Party","VotingMatter"))
MemberVarianceAggr = 
  MemberVariance[Party!="Fraktionslos", 
                 .(MeanVotingDifference = mean(abs(YesFloat - Mean))), 
                 by = .(Party, Member)]

saveRDS(MemberVarianceAggr, "./r_data/member_variance_dt.RDS")

member_varience_boxplot = 
  plot_ly(MemberVarianceAggr, y = ~MeanVotingDifference, color = ~Party, 
          colors = get_color_palette(unique(MemberVarianceAggr$Party)),
          type = "box", text=~Member) %>%
  layout(title = 'Variance of members within the party')

################################################################################
###      Make PCA View                                                       ###
#   Project the voting space into lower dimensions                             #

unique_member  = unique(DT$Member)
party_per_row = DT[1:NROW(unique_member)]$Party

abs_mat = matrix(0, NROW(unique_member), NROW(unique_voting_matter))
rownames(abs_mat) = unique_member
colnames(abs_mat) = unique_voting_matter

for (i in 1:NROW(unique_voting_matter)){
  abs_mat[,i] = DT[VotingMatter == unique_voting_matter[i]]$YesFloat
}

PCA = princomp(abs_mat, cor = TRUE, scores = TRUE)

################################################################################
###      Explain variance                                                    ###

VarianceExplained = 
  data.table( "Explained Variance" =((PCA$sdev^2)/sum(PCA$sdev^2)), 
              "Component" = paste0("Comp.", c(1:length(PCA$sdev))))

VarianceExplained$Component = 
  factor(VarianceExplained$Component, 
         levels = c(as.character(VarianceExplained$Component)))

saveRDS(VarianceExplained, "./r_data/pca_variances.RDS")

variance_explained_plot = 
  plot_ly(VarianceExplained[1:10], y=~`Explained Variance`, 
          x=~Component, type = "bar") %>% 
  layout(xaxis=list(title=FALSE))

################################################################################
###      Plot data mapped on first pca components                            ###

PCA_loc2d = PCA$scores[,c(1,2)]
PCA_loc3d = PCA$scores[,c(1,2,3)]

PCA$loadings

loc = cbind(PCA_loc3d,party_per_row)
PCA_for_Plot3d = data.frame(x = as.numeric(loc[,1]), 
                            y = as.numeric(loc[,2]), 
                            z = as.numeric(loc[,3]), 
                            color = loc[,4], 
                            text = unique_member)
PCA_for_Plot3d$color = as.factor(PCA_for_Plot3d$color)

loc = cbind(PCA_loc2d,party_per_row)
PCA_for_Plot2d = data.frame(x = as.numeric(loc[,1]), 
                            y = as.numeric(loc[,2]), 
                            color = loc[,3], 
                            text = unique_member)
PCA_for_Plot2d$color = as.factor(PCA_for_Plot2d$color)

saveRDS(PCA_for_Plot2d, "./r_data/pca_2d_dt.RDS")
saveRDS(PCA_for_Plot3d, "./r_data/pca_3d_dt.RDS")


pca_2d = plot_ly(PCA_for_Plot2d, x = ~x, y = ~y, color = ~color, 
                 colors = COLOR_PAL, type = "scatter", mode = "markers", 
                 text = ~text, hovertemplate = paste('%{text}'),
                 opacity= 0.7, marker =list(size = 12)) %>% 
  layout(xaxis=list(title=FALSE), yaxis=list(title=FALSE))

pca_3d = plot_ly(PCA_for_Plot3d, x = ~x, y = ~y, z = ~z, color = ~color, 
                 colors = COLOR_PAL, text = ~text, 
                 hovertemplate = paste('%{text}'), type = "scatter3d", 
                 mode = "markers", opacity= 0.7, marker =list(size = 12)) %>% 
  layout(xaxis=list(title=FALSE), yaxis=list(title=FALSE))



