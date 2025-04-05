# Time tree of Orobanchaceae

## I. Time tree backbone
1. The backbone of the time tree is derived from [Mortimer et al 2022](https://doi.org/10.1600/036364422X16512564801560). We expanded taxon sampling within Agalinis following [Latvis et al 2024](https://doi.org/10.1600/036364424X17095905880222), Brandisia following [Chen et al 2022](https://doi.org/10.1016/j.pld.2023.03.005), Lamrourouxia following [Mortimer 2019](chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://objects.lib.uidaho.edu/etd/pdf/Mortimer_idaho_0089N_11516.pdf).

2. To merge clade-specific phylogenies (with branch length in mutational units) with the Orobanchaceae family-wise time tree (referred to as the mortimer tree), we conducted individual divergence time estimation for each clade using the secondary calibration from the mortimer tree in `TreePL`. We primed, cross validated, and conducted thorough time tree search in `TreePL`. This step need to be done for Agalinis and Lamourouxia.

The original clade specific phylogenies, treePL control file, and calibrated time trees can be found in the subfolder `input_trees`.

## II. Adding species using GenBank sequences
1. To further add species with plastid/ITS sequences avaiable from GenBank, we downloaded the rbcL, matK, trnL, ITS sequences of these species and their close relatives to reconstruct a ML phylogeny in IQ-TREE. The GenBank accession number is provided in `GenBank_accession.xlsx` and the individual alignments can be found in the subfolder `Genbank_seqs`.

2. We subseqeuntly used secondary calibration from the mortimer tree to conduct divergence time estimation using treePL.

3. We finally added these species to the time tree manually.

### III. Taxonomy- and biogeography-informed placement of uncertain species

We sampled around 20 species with no sequences available. For these species, they were placed using our best knowledge of their phylogenetic position based on taxonomy or biogeography. The reference used to constrain their phylogenetic position is provided in ##. We used the `bond.tip` function from the R package phytools to facilitate species addition on a time tree. See the R script `add_tip_to_tree.R` for details.
