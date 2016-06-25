function h=plotSingVO(vo)
    h1= plot(vo([1,2],1), vo([1,2],2));
    h2= plot(vo([1,3],1), vo([1,3],2));
    h = [h1, h2];
end