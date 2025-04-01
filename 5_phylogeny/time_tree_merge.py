from ete3 import Tree
x=open('/Users/limingcai/Documents/GitHub/Leaf_evolution/5_phylogeny/mortimer_backbone_sp.list').readlines()
x=[i.strip() for i in x]
t=Tree('/Users/limingcai/Documents/GitHub/Leaf_evolution/5_phylogeny/mortimer.tre')
sp=[node.name for node in t]

#confirm that all species in the list is in the tree

[i for i in x if not i in sp]

t.prune(x,preserve_branch_length=True)