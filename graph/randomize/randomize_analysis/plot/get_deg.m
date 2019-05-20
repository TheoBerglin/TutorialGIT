clc, clear all, close all;
nodes = 200;
dens = 0.01;
directed = false;
weighted = true;
type = Graph.WU;
filename = 'deg_wu_200_001.mat';

A = create_matrix(dens, nodes, directed, weighted);

rA_bct = randomize_bct_U(A);
rA_bct_edit = randomize_bct_U_edit(A);
rA_braph = randomize_braph_WU(A);

bct_deg = degree(rA_bct, type);
bct_edit_deg = degree(rA_bct_edit, type);
braph_deg = degree(rA_braph, type);

bct_wei = rA_bct(rA_bct > 0);
bct_edit_wei = rA_bct_edit(rA_bct_edit > 0);
braph_wei = rA_braph(rA_braph > 0);

save(filename, 'bct_deg', 'bct_edit_deg', 'braph_deg', 'bct_wei', 'bct_edit_wei', 'braph_wei')

