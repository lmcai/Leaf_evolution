function MaxLen=linear_leaf_len(bw)
	bw = imfill(bw,'holes');
	sk_bw = skeleton(bw)>20;