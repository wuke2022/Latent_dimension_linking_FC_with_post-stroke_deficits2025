library(ggplot2)
library(grid)
library(ggpubr)
library(tidyverse)
library(hrbrthemes)
library(viridis)
library(svglite)
library(ggstatsplot)
library(rstatix)
library(RColorBrewer)
library(ComplexHeatmap)
library(gridExtra)
library(circlize)
library(igraph)
###############################################  plot explain. scatters ####################################################
template='Gordon333'
data = read.table(paste('D:/Figure_Results/Part1_PLSC_Plot/',template,'_rawy/explCovLC.csv',sep=''), header=FALSE, sep=",")

domain <- seq(from=1,to=nrow(data))
fillcol <- c('red',rep("#7D7C7C",40))
df <- data.frame(domains=domain, fillcol=fillcol,sub=data[,c(1)])
df$domains <- factor(df$domains)
order<-factor(df$domains,levels=domain);

ggplot(df,aes(x=order,y=sub,fill=fillcol ))+
  geom_point(color=fillcol,size=5)+
  scale_y_continuous(breaks=seq(0,0.8,0.1))+
  scale_x_discrete(breaks=seq(0,45,10))+
  ggtitle('')+xlab(expression(paste("Number of ", italic("LC"))))+ylab('Explained variance')+
  theme_classic(base_family='Times',base_size=24)+
  theme(plot.title=element_text(hjust=0.5,face="bold",size=24),axis.text.x=element_text(size=22),axis.text.y=element_text(size=22),legend.position = "none")+
  theme(axis.line.x=element_line(size=1),axis.line.y=element_line(size=1),axis.ticks.x=element_line(size=1,lineend=10),axis.ticks.y=element_line(size=1,lineend=10))
ggsave(paste('D:/Figure_Results/Part1_PLSC_Plot/',template,'_rawy/explCovLC_A.png',sep=''),  width = 13, height = 15, units="cm", dpi=1000, bg="white")

###############################################  plot sig. scatters ####################################################
template='Gordon333'
data = read.table(paste('D:/Figure_Results/Part1_PLSC_Plot/',template,'_rawy/LxLy.csv',sep=''), header=TRUE, sep=",")
df = data[,c(1,2)]

ggplot(df,aes(x=lx_a ,y=ly_a))+
  #geom_point(size=4,color='#3652AD')+
  geom_point(size=4,shape=21,color="#0245A3",fill="#8FBAF3")+
  stat_smooth(method=lm,se=FALSE,size=1.5)+
  ggtitle('')+xlab('RSFC composite score')+ylab('Behavioral composite score')+
  theme_classic(base_family='Times',base_size=24)+
  theme(plot.title=element_text(hjust=0.5,face="bold",size=24),axis.text.x=element_text(size=22),axis.text.y=element_text(size=22))+# 0 = left, 0.5 = center, 1 = right
  theme(axis.line.x=element_line(size=1),axis.line.y=element_line(size=1))+
  theme(axis.ticks.x=element_line(size=1,lineend=10),axis.ticks.y=element_line(size=1,lineend=10))+
  geom_smooth(method='lm',se = TRUE,color="#0245A3",size=1.5)
ggsave(paste('D:/Figure_Results/Part1_PLSC_Plot/',template,'_rawy/LxLy_A.png',sep=''),  width = 18, height = 17, units="cm", dpi=1000, bg="white")
###############################################  plot sig. histogram ####################################################
template='Gordon333'
perm_data = read.table(paste('D:/Figure_Results/Part1_PLSC_Plot/',template,'_rawy/permsamp.csv',sep=''), header=FALSE, sep=",")
df = data.frame(acute=perm_data[,c(1)],subacute=perm_data[,c(2)],chronic=perm_data[,c(3)],HC1=perm_data[,c(4)],HC2=perm_data[,c(5)])
ggplot(df,aes(x=acute ))+
  geom_histogram(binwidth=5,color="black")+# "#8FBAF3"
  theme_minimal()+
  xlab('')+
  theme(axis.line.y = element_blank(),  
        axis.text.y = element_blank(),   
        axis.title.y = element_blank(),  
        panel.grid.major = element_blank(),  
        panel.grid.minor = element_blank(),
        axis.text.x=element_text(size=38)) +
  geom_vline(aes(xintercept=11413),linetype='dashed',size=2,color="black")# "#0245A3"   a=11413 c=8036.2 c2= 7725.9 hc1=4753.5 hc2=3910.6
ggsave(paste('D:/Figure_Results/Part1_PLSC_Plot/',template,'_rawy/histogram_A.eps',sep=''),  width = 20, height = 15, units="cm", dpi=1000, bg="white",device='eps')
###############################################  plot sig. bar ####################################################
template='Gordon333'
data = read.table(paste('D:/Figure_Results/Part1_PLSC_Plot/',template,'_rawy/behav_loadings.csv',sep=''), header=FALSE, sep=",")

test=c('pos_acc_avg',	'pos_acc_vf',	'pos_acc_valid',	'pos_acc_disen',	'pos_rt_avg',	'pos_rt_vf',	'pos_rt_validity','pos_rt_disen',	'bit_coc',	'mes_coc'	,
       'word',	'commands',	'complex',	'boston',	'read','read_comp',	'nonword',	'stem',	'animal'	,
       'lshflex',	'rshflex',	'lwrext',	'rwrext',	'lgrip'	,'rgrip',	'lpegs','rpegs'	,'laratotal'	,'raratotal',	'walk_total',	'ltot_mot',	'rtot_mot',	'lankflex'	,'rankflex',
       'bvmt_imt',	'bvmt_delayt','hvlt_discrim',	'hvlt_imt',	'hvlt_delayt'	,'ss_for',	'ss_back')
domain <- rep(c('Attn','Lan','Mot','SMem','VMem','SMem'),times=c(10,9,15,2,3,2))

df <- data.frame(domains=domain, test=test, stage=data[,c(1)],std=data[,c(6)])
df$domains <- factor(df$domains)
myrank=sort(abs(df$stage),decreasing=TRUE);thresh=myrank[30]
df<-subset(df,df$stage>=thresh | df$stage<=-thresh)
order_level <- c('word',	'commands',	'complex',	'boston',	'read','read_comp',	'nonword',	'stem',	'animal',
                 'bvmt_imt',	'bvmt_delayt','ss_for',	'ss_back',
                 'hvlt_discrim',	'hvlt_imt',	'hvlt_delayt'	,
                 'lshflex',	'rshflex',	'lwrext',	'rwrext',	'lgrip'	,'rgrip',	'lpegs','rpegs'	,'laratotal'	,'raratotal',	'walk_total',	'ltot_mot',	'rtot_mot',	'lankflex'	,'rankflex',
                 'pos_acc_avg',	'pos_acc_vf',	'pos_acc_valid',	'pos_acc_disen',	'pos_rt_avg',	'pos_rt_vf',	'pos_rt_validity','pos_rt_disen',	'bit_coc',	'mes_coc'	)
order<-factor(df$test,levels=order_level);
colors<-c('Lan'="#DF7000",'SMem'="#007900",'VMem'="#035FDA",'Mot'= "#7331A4",'Attn'="#023882")
ggplot(df,aes(x=order,y=stage,fill=domains ))+
  geom_bar(stat='identity',position=position_dodge(),width=0.8,color="black")+
  geom_errorbar(aes(ymin=stage-std,ymax=stage+std),width=0.15,size=0.6,position=position_dodge())+ 
  scale_fill_manual(values=colors,guide='none')+
  scale_y_continuous(breaks=seq(-0.9,0.9,0.2))+
  ggtitle('')+xlab('')+ylab('Correlation')+
  theme_classic(base_family='Times',base_size=32)+
  theme(plot.title=element_text(hjust=0.5,face="bold",size=28),axis.text.x=element_text(size=22,angle=45,vjust=1,hjust=1),axis.text.y=element_text(size=25))+
  theme(axis.line.x=element_line(size=1),axis.line.y=element_line(size=1),axis.ticks.x=element_line(size=1,lineend=10),axis.ticks.y=element_line(size=1,lineend=10))+#axis.ticks.x=element_blank()
  geom_hline(aes(yintercept=0),size=14/22)
ggsave(paste('D:/Figure_Results/Part1_PLSC_Plot/',template,'_rawy/behav_loadings_A_unthresh.png',sep=''), width = 38, height = 22, units="cm", dpi=1000, bg="white")
###############################################  plot Grodon333. heatmap ####################################################
data = read.table("D:/Figure_Results/Part1_PLSC_Plot/Gordon333_rawy/matrix_acute.csv",header=FALSE, sep=",")
Node <- 1:333
Network <- rep(c('Visual','SMhand','SMmouth','Auditory','CinguloOperc','VentralAttn','Salience','DorsalAttn','FrontoParietal','Default','CinguParietal','RestroTemporal','None',
                 'Visual','SMhand','SMmouth','Auditory','CinguloOperc','VentralAttn','Salience','DorsalAttn','FrontoParietal','Default','CinguParietal','RestroTemporal','None'),
               times=c(18,18,4,12,20,11,2,19,9,20,3,4,21,
                       21,20,4,12,20,12,2,13,15,21,2,4,26))
df <- as.matrix(data)
rownames(df)<-Node
colnames(df)<-Node
bk<-c(seq(-1,1,by=0.01))
col<- colorRampPalette(c("cyan","blue", "black", "red","yellow"))(length(bk))
myannotation=data.frame(Network=Network)
rownames(myannotation)<-Node
mycolors<-c("#C443F9","#89FBFB","#E59320","#F8EB31","#7A8732","#29DA29",'#781286','#FF98D5',"#2986F9",'#FF0000',"#213F99","#985530","black")
names(mycolors)<-unique(myannotation$Network)
mycolors<-list(Network=mycolors)
pheatmap(df,cluster_cols=F,cluster_rows=F,scale="none",treeheight_col=0,treeheight_row=0,
         color=col,show_colnames=FALSE,show_rownames=FALSE,
         annotation_row=myannotation,annotation_col=myannotation,annotation_color=mycolors, # 加行列注释
         annotation_names_row = FALSE,annotation_names_col = FALSE,
         legend = FALSE,annotation_legend= FALSE,cellwidth=1,cellheight=1) #,gaps_col=149,gaps_row=149
##### add line
marks=c(26,30,32,53,68, 81,83,95,115,127,131,151,172,193,197,200,220,229,248,250,261,281,293,297,315)
for (k in marks){
  nr=(1-17/460)*k/333
  grid.lines(x = c(unit(0, "npc"), unit(1, "npc")),
             y = unit(c(nr, nr), "npc"),       # c(0.6,0.6), y=0.6
             gp = gpar(col = "white", lwd = 0.001))
}
marks1=c(18,36,40,52,72,83,85,104,113,133,136,140,161,182,202,206,218,238,250,252,265,280,301,303,307)
for (k in marks1){
  nr=(1-17/460)*k/333+(17/460)
  grid.lines(y = c(unit(0, "npc"), unit(1, "npc")),
             x = unit(c(nr, nr), "npc"),       # c(0.6,0.6), y=0.6
             gp = gpar(col = "white", lwd = 0.001))
}
###############################################  plot sig. chord ####################################################
template='Gordon333'
inputpath=paste('D:/Figure_Results/Part1_PLSC_Plot/',template,'_rawy/chord_data_A.csv',sep='')
link_colorscale = 'bwr'
min_thre = 0.00000001
max_thre = 0.4
outname = paste('D:/Figure_Results/Part1_PLSC_Plot/',template,'_rawy/chord_A.png',sep='')
# load data
# load data
data <- read.csv(inputpath, header=FALSE)
networks = c('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26')
colnames(data) <- as.numeric(networks)
rownames(data) <- as.numeric(networks)
d <- data.matrix(data)
g <- graph.adjacency(d, mode="undirected",weighted=TRUE)
df <- get.data.frame(g)

# outer track parameters
outer_color = rep('#000000', 13)
outer_textcol = '#7B7D7D' 
outer_textcol = '#000000'
outer_fontsize = 3

# inner track parameters
inner_labels = rep(' ',26)
inner_color = c("#C443F9","#89FBFB","#E59320","#F8EB31","#7A8732","#29DA29",'#781286','#FF98D5',"#2986F9",'#FF0000',"#213F99","#985530","black",
                "black","#985530","#213F99", '#FF0000', "#2986F9",'#FF98D5','#781286', "#29DA29", "#7A8732", "#F8EB31","#E59320", "#89FBFB", "#C443F9" )
inner_textcol = rep('#000000', 26)
inner_textcol[2] = '#FFFFFF'
inner_textcol[6] = '#FFFFFF'
inner_textcol[17] = '#FFFFFF'
inner_fontsize = 1.5
###
# output the figure as png
###
png(paste(outname,'.png',sep=''), width=10, height=10, units="in", res=300)
# start circos plot
lg = 4 
gap_vec = c(1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, lg, 1, 1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1,lg)
circos.par("start.degree"= 90,"gap.after"= gap_vec, unit.circle.segments= 10000, canvas.ylim=c(-1.2,1))

f = factor(networks, levels = networks)
circos.initialize(factors = f, xlim = c(0, 1))
# 1st track
circos.track(factors = f, ylim = c(0, 1), "track.height"= 0.02, track.margin = c(0.01, 0), 
             bg.border='white', cell.padding=c(0,1,0,1))
highlight.sector(c('1','2','3', '4','5', '6','7','8','9','10','11','12','13'), track.index = 1, col = outer_color[1], text = outer_labels[1], 
                 text.col = outer_textcol, text.vjust = "7mm", font = 2, cex=outer_fontsize, niceFacing=TRUE,family=('time'))

highlight.sector(c('14','15','16','17','18','19','20','21','22','23','24','25','26'), track.index = 1, col = outer_color[2], text = outer_labels[2], 
                 text.col = outer_textcol, text.vjust = "7mm", font = 2, cex=outer_fontsize, niceFacing=TRUE)
# 2nd track
circos.track(factors = f, ylim = c(0, 1), "track.height"= 0.1, bg.col = inner_color, bg.lwd = rep(2, 26))
circos.trackText(f, rep(0.5, 26), rep(0.5, 26), inner_labels, track.index = 2, facing="bending", 
                 niceFacing = TRUE, font=2, cex=inner_fontsize, col=inner_textcol)
# links
ind = !(df$weight < min_thre & df$weight > -min_thre)
df = df[ind,]
df$weight[df$weight > max_thre] = max_thre
df$weight[df$weight < -max_thre] = -max_thre+1e-10
resolution <- 40
if (min_thre == 0){
  breaks = c(seq(-max_thre, max_thre, length.out = resolution))
} else {
  breaks = c(seq(-max_thre,-min_thre,length.out = resolution/2), 
             seq(min_thre, max_thre, length.out = resolution/2))
}

df$color_level <- cut(df$weight, breaks, labels=FALSE)
# generate bwr color
# bwr <- colorRampPalette(c("blue","white","red"))
# bwr_colors = bwr(resolution)
if (link_colorscale == 'bwr'){
  bwr <- colorRamp2(c(-1, 0, 1), c("blue","white","red"), space='RGB')
  link_colors = bwr(seq(-1, 1, length.out=resolution))
}
if  (link_colorscale == 'bkr'){
  link_colors = scan("bkr_colorscale.txt", what="character", sep="\n")
  bkr = function(vector){
    return(link_colors[vector])
  }
}

len = max(table(c(df$from,df$to))) + 1.1
link_breaks <- seq(0, 1, length.out=len)
count = rep(1, 26)
for (row in 1:nrow(df)) {
  from <- df[row, "from"]
  to <- df[row, "to"]
  color_level <- df[row, "color_level"]
  if (from == to) {
    from_num = as.numeric(from)
    circos.link(from, link_breaks[1:2], to, link_breaks[(len-1):len], col=link_colors[color_level])
  } else {
    from_num = as.numeric(from)
    to_num = as.numeric(to)
    count[from_num] <- count[from_num] + 1
    count[to_num] <- count[to_num] + 1
    #print(link_breaks[count[from_num]:(count[from_num]+1)])
    circos.link(from, link_breaks[count[from_num]:(count[from_num]+1)], to, 
                link_breaks[count[to_num]:(count[to_num]+1)], col=link_colors[color_level])
  }
}
# add color bar
if (link_colorscale == 'bwr'){
  color_bar = Legend(at=c(-1,-0.2,0.2,1), 
                     labels=c(-max_thre,-min_thre,min_thre,max_thre), 
                     col_fun=bwr, grid_height = unit(4, "mm"), grid_width = unit(6, "mm"), 
                     labels_gp = gpar(fontsize = 20), direction = "horizontal")
}
if (link_colorscale == 'bkr'){
  color_bar = Legend(at=c(1,30,51,80), 
                     labels=c(-max_thre,-min_thre,min_thre,max_thre), 
                     col_fun=bkr, grid_height = unit(4, "mm"), grid_width = unit(6, "mm"), 
                     labels_gp = gpar(fontsize = 20), direction = "horizontal")
}
grid.arrange(nullGrob(), bottom=color_bar, newpage = FALSE)
dev.off()
###############################################  plot gradient corr. scatters ####################################################
template='Gordon333'
data = read.table(paste('D:/Figure_Results/Part1_PLSC_Plot/',template,'_rawy/corr_gradient.csv',sep=''), header=TRUE, sep=",")
df = data[,c(1,2)]
prettyZero <- function(l){
  max.decimals = 2
  lnew = formatC(l, replace.zero = T, zero.print = "0",
                 digits = max.decimals, format = "f", preserve.width=T)
  return(lnew)
}
prettyZero0 <- function(l){
  max.decimals = 0
  lnew = formatC(l, replace.zero = T, zero.print = "0",
                 digits = max.decimals, format = "f", preserve.width=T)
  return(lnew)
}
ggplot(df,aes(x=my_loading ,y=-hcp_gradient))+
  geom_point(size=4,shape=21,color="#0245A3",fill="#8FBAF3")+
  stat_smooth(method=lm,se=FALSE,size=1.5)+
  scale_y_continuous(limits=c(-9,9),breaks=seq(-8,8,4),labels=prettyZero0)+
  scale_x_continuous(limits=c(-0.13,0.15),breaks=seq(-0.15,0.15,0.05),labels=prettyZero)+
  ggtitle('')+xlab('Sum of RSFC loadings')+ylab('Principal gadient of HCP data')+
  theme_classic(base_family='Times',base_size=24)+
  theme(plot.title=element_text(hjust=0.5,face="bold",size=24),axis.text.x=element_text(size=22),axis.text.y=element_text(size=22))+# 0 = left, 0.5 = center, 1 = right
  theme(axis.line.x=element_line(size=1),axis.line.y=element_line(size=1))+
  theme(axis.ticks.x=element_line(size=1,lineend=10),axis.ticks.y=element_line(size=1,lineend=10))+
  geom_smooth(method='lm',se = TRUE,color="#0245A3",size=1.5)
ggsave(paste('D:/Figure_Results/Part1_PLS
