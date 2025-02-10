function KSchur = Kron_Schur(Bbus,index_keep,index_delete)

Y1 = Bbus(index_keep,index_keep);
Y2 = Bbus(index_keep,index_delete);
Y4 = Bbus(index_delete,index_delete);
Y3 = Bbus(index_delete,index_keep);
KSchur = Y1 - Y2*(Y4)^(-1)*Y3;

end