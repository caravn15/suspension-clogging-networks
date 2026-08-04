function consInds = LoadConsIndsFig6()

T        = readtable('data/net/Brown-et-al-retina/data_consInds.csv');
T        = table2array(T);
consInds = T(:,1);

end