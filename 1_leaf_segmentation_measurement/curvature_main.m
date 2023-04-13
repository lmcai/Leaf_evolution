hain = mk_chain('/Users/lcai/Downloads/Orobanchaceae_leaf_architecture/leaf_shape/022322/S30_1_59.91ppm.bw.png');
[cc] = chaincode(chain);
x_ = calc_traversal_dist(transpose([cc.code]));
coor = [0 0; x_];
[L2,R2,K2] = curvature(coor);