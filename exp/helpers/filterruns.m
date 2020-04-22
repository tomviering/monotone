function r2 = filterruns(r, runs)

    r2 = r;
    r2.error = r2.error(:,:,runs);
    r2.xval = r2.xval(:,:,runs);
    r2.xval2 = r2.xval2(:,:,runs);
    r2.reptime = r2.reptime(:,runs);
    r2.non_monotone = r2.non_monotone(:,:,runs);

end