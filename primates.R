require(ape)
genera_set <- read.nexus("mt.genera.ucld.trees")
nuc_set <- read.nexus("nuc.ucld.trees")
genera <- genera_set[[1]]
nuc <- nuc_set[[1]]
nuc_names <- nuc$tip.label
genera_names <- genera$tip.label
traits <- read.csv("Primate_brain_comparisons.csv")

dups <- duplicated(traits[['Genus']])
trait_names <- as.character(traits$Genus[!dups])
x <- traits$log_brain.weight[!dups]
names(x) <- trait_names


compare <- treedata(nuc, x)
plot(compare$phy)
out <- ace(compare$data, compare$phy)

# a similar function but for the continuous ancestral state 
plot_cts_ancestor <- function(phy, data, ancestral){	
	plot(phy) # just to get treelength 
	treelen <- max(axisPhylo() )
	plot(compare$phy, cex=1, x.lim=1.3*treelen, edge.width=2)
	mycol <- function(x){
	tmp = (x - min(data)) /max(x-min(data)) 
	rgb(blue = 1-tmp, green=0, red = tmp )
	}
	nodelabels(pch=19, col=mycol(ancestral$ace), cex=1.5  )
	tiplabels(pch=19, col=mycol(data), cex=1.5, adj=0.5) # add tip color code
	}
plot_cts_ancestor(compare$phy, compare$data, out)
