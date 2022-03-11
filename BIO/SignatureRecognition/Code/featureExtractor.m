function FeatVect = featureExtractor(x,y,p)

    T = Ttotal(x);
    Npu = Npenups(p);
    Tpd = Tpendown(p);
    Ppd = Ppendown(p);
    
    FeatVect=[T, Npu, Tpd, Ppd];

end
