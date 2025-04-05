library(phytools)

tree <- read.tree('~/Documents/GitHub/Leaf_evolution/5_phylogeny/Orobanchaceae_complete.tre') 
#The phylogeny has to be ultrametric, otherwise this error message occurs and the new tree with added taxa will not have branch length:
#Warning message:
#In bind.tree(tree, tip, where = where, position = pp) :
#  one tree has no branch lengths, they have been ignored

tree=force.ultrametric(tree, method="nnls")

#plot(tree)  # Visualize the tree
#nodelabels()  # Show node numbers


#########################
#Use the following code to add taxa with divergence time
# Define two taxa
taxon1 <- "Leucosalpa_madagascariensis"
taxon2 <- "Anisantherina_hispidula"
mrca_node <- findMRCA(tree, c(taxon1, taxon2))
#node <- which(tree$tip.label=="t5")

##IMPORTANT: the 'position' parameter is the branch length where tips should be added, not the age (cumulative branch length)
tree <- bind.tip(tree, tip.label="Pseudomelasma_pediculariodes",where=mrca_node, position=0.1)

taxon1 <- "Leucosalpa_madagascariensis"
taxon2 <- "Pseudomelasma_pediculariodes"
mrca_node <- findMRCA(tree, c(taxon1, taxon2))
tree <- bind.tip(tree, tip.label="Rhaphispermum_gerardioides",where=mrca_node, position=0.1)


taxon1 <- "Lamourouxia_multifida"
taxon2 <- "Lamourouxia_viscosa"
mrca_node <- findMRCA(tree, c(taxon1, taxon2))
tree <- bind.tip(tree, tip.label="Silviella_prostrata",where=mrca_node, position=2.321)

taxon1 <- "Xizangia_bartschioides"
taxon2 <- "Pterygiella_duclouxii"
mrca_node <- findMRCA(tree, c(taxon1, taxon2))
tree <- bind.tip(tree, tip.label="Parasopubia_delphiniifolia",where=mrca_node, position=2.321)

taxon1 <- "Cycnium_adonense"
taxon2 <- "Buchnera_americana"
mrca_node <- findMRCA(tree, c(taxon1, taxon2))
tree <- bind.tip(tree, tip.label="Thunbergianthus_ruwenzoriensis",where=mrca_node, position=1.8902)

taxon1 <- "Lamourouxia_multifida"
taxon2 <- "Lamourouxia_viscosa"
mrca_node <- findMRCA(tree, c(taxon1, taxon2))
tree <- bind.tip(tree, tip.label="Vellosiella_spathacea",where=mrca_node, position=1.921)

node=which(tree$tip.label=="Vellosiella_spathacea")
tree <- bind.tip(tree, tip.label="Vellosiella_westermanii",where=node, position=2.4367)

node=which(tree$tip.label=="Brandisia_scandens")
tree <- bind.tip(tree, tip.label="Brandisia_chevalieri",where=node, position=0.4738)

taxon1 <- "Neobartsia_pedicularoides"
taxon2 <- "Neobartsia_thiantha"
mrca_node <- findMRCA(tree, c(taxon1, taxon2))
tree <- bind.tip(tree, tip.label="Neobartsia_laticrenata",where=mrca_node, position=0.1232)

taxon1 <- "Brandisia_scandens"
taxon2 <- "Brandisia_chevalieri"
mrca_node <- findMRCA(tree, c(taxon1, taxon2))
tree <- bind.tip(tree, tip.label="Brandisia_discolor",where=mrca_node, position=2.7262)

taxon1 <- "Buchnera_americana"
taxon2 <- "Buchnera_floridana"
mrca_node <- findMRCA(tree, c(taxon1, taxon2))
tree <- bind.tip(tree, tip.label="Buchnera_pusilla",where=mrca_node, position=0.7150)


write.tree(tree,outfile='Orobanchaceae_complete.tre')