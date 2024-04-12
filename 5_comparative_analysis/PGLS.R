library(ape)
library(nlme)
library(geiger)

library(caper)

data <- read.csv("Oro_leaf_climate.csv")

###########################################################################
#GLS without phylogeny: correlation between leaf size and climate
model1=gls(area_mm ~ BIO1*BIO12*elevation, data=data,na.action = na.omit)
summary(model1)

Generalized least squares fit by REML
  Model: area_mm ~ BIO1 * BIO12 * elevation 
  Data: data 
       AIC      BIC    logLik
  1122.675 1139.702 -552.3376

Coefficients:
                         Value Std.Error    t-value p-value
(Intercept)          -3212.449  6598.420 -0.4868513  0.6285
BIO1                   184.524   380.622  0.4847965  0.6300
BIO12                    7.983     7.026  1.1361060  0.2614
elevation                1.954     4.143  0.4715526  0.6393
BIO1:BIO12              -0.340     0.354 -0.9594344  0.3421
BIO1:elevation          -0.111     0.281 -0.3949802  0.6946
BIO12:elevation         -0.004     0.005 -0.8248605  0.4134
BIO1:BIO12:elevation     0.000     0.000  0.6393626  0.5256

 Correlation: 
                     (Intr) BIO1   BIO12  elevtn BIO1:BIO12 BIO1:l BIO12:
BIO1                 -0.898                                              
BIO12                -0.912  0.744                                       
elevation            -0.798  0.752  0.768                                
BIO1:BIO12            0.898 -0.879 -0.936 -0.796                         
BIO1:elevation        0.583 -0.740 -0.506 -0.844  0.677                  
BIO12:elevation       0.673 -0.582 -0.776 -0.906  0.769      0.694       
BIO1:BIO12:elevation -0.571  0.623  0.631  0.868 -0.744     -0.868 -0.916

Standardized residuals:
        Min          Q1         Med          Q3         Max 
-0.93773684 -0.34080578 -0.13285566  0.01735789  5.33052159 

Residual standard error: 4219.141 
Degrees of freedom: 57 total; 49 residual


###########################################################################
#GLS without phylogeny: correlation between leaf aspect ratio and climate
model1=gls(Aspect_ratio_width.length ~ BIO1*BIO12*elevation, data=data,na.action = na.omit)
summary(model1)
Generalized least squares fit by REML
  Model: Aspect_ratio_width.length ~ BIO1 * BIO12 * elevation 
  Data: data 
       AIC      BIC    logLik
  153.6949 170.7213 -67.84747

Coefficients:
                          Value Std.Error    t-value p-value
(Intercept)           0.3163062 0.3352202  0.9435774  0.3500
BIO1                 -0.0032173 0.0193368 -0.1663815  0.8685
BIO12                 0.0000740 0.0003570  0.2071970  0.8367
elevation            -0.0001696 0.0002105 -0.8056831  0.4243
BIO1:BIO12            0.0000025 0.0000180  0.1413736  0.8882
BIO1:elevation        0.0000134 0.0000143  0.9348375  0.3545
BIO12:elevation       0.0000003 0.0000003  0.9517498  0.3459
BIO1:BIO12:elevation  0.0000000 0.0000000 -1.2777929  0.2073

 Correlation: 
                     (Intr) BIO1   BIO12  elevtn BIO1:BIO12 BIO1:l BIO12:
BIO1                 -0.898                                              
BIO12                -0.912  0.744                                       
elevation            -0.798  0.752  0.768                                
BIO1:BIO12            0.898 -0.879 -0.936 -0.796                         
BIO1:elevation        0.583 -0.740 -0.506 -0.844  0.677                  
BIO12:elevation       0.673 -0.582 -0.776 -0.906  0.769      0.694       
BIO1:BIO12:elevation -0.571  0.623  0.631  0.868 -0.744     -0.868 -0.916

Standardized residuals:
        Min          Q1         Med          Q3         Max 
-1.49122931 -0.78501892 -0.06524949  0.45326886  2.60083857 

Residual standard error: 0.2143455 
Degrees of freedom: 57 total; 49 residual

###########################################################################
#GLS without phylogeny: correlation between leaf Circularity and climate
Generalized least squares fit by REML
  Model: Circularity ~ BIO1 * BIO12 * elevation 
  Data: data 
       AIC     BIC    logLik
  144.1897 161.216 -63.09483

Coefficients:
                          Value  Std.Error    t-value p-value
(Intercept)           0.3728508 0.30423335  1.2255421  0.2262
BIO1                  0.0083598 0.01754932  0.4763600  0.6359
BIO12                -0.0000307 0.00032396 -0.0948913  0.9248
elevation            -0.0003100 0.00019104 -1.6225027  0.1111
BIO1:BIO12            0.0000019 0.00001634  0.1147191  0.9091
BIO1:elevation        0.0000113 0.00001296  0.8694730  0.3888
BIO12:elevation       0.0000005 0.00000024  2.1966266  0.0328
BIO1:BIO12:elevation  0.0000000 0.00000001 -1.9102632  0.0620

 Correlation: 
                     (Intr) BIO1   BIO12  elevtn BIO1:BIO12 BIO1:l BIO12:
BIO1                 -0.898                                              
BIO12                -0.912  0.744                                       
elevation            -0.798  0.752  0.768                                
BIO1:BIO12            0.898 -0.879 -0.936 -0.796                         
BIO1:elevation        0.583 -0.740 -0.506 -0.844  0.677                  
BIO12:elevation       0.673 -0.582 -0.776 -0.906  0.769      0.694       
BIO1:BIO12:elevation -0.571  0.623  0.631  0.868 -0.744     -0.868 -0.916

Standardized residuals:
       Min         Q1        Med         Q3        Max 
-1.7799846 -0.7613217  0.0428946  0.8654194  1.7591352 

Residual standard error: 0.194532 
Degrees of freedom: 57 total; 49 residual







data$Class_code=as.factor(data$Class_code)
phy_tree=read.tree('round3.mt37g_42sp.treePL.tre')
phy_tree$node.label<-NULL
name.check(data,phy_tree)

######################################################################################
####PGLS
data_clean=data[data$Phylogeny_tip!='',]
oro_tree<-read.tree("Orobanchaceae_Mortimer_pruned.tre")

oro_tree$node.label<-NULL
model2<-pgls(area_mm~BIO1*BIO12, data=comp.data)
Call:
pgls(formula = area_mm ~ BIO1 * BIO12, data = comp.data)

Residuals:
    Min      1Q  Median      3Q     Max 
-110.30  -53.70  -15.80   22.56  175.97 

Branch length transformations:

kappa  [Fix]  : 1.000
lambda [Fix]  : 1.000
delta  [Fix]  : 1.000

Coefficients:
               Estimate  Std. Error t value Pr(>|t|)
(Intercept) -51.7783243 318.5219415 -0.1626   0.8726
BIO1         24.6503243  15.4943986  1.5909   0.1281
BIO12         0.1311602   0.2359554  0.5559   0.5848
BIO1:BIO12   -0.0092495   0.0103706 -0.8919   0.3836

Residual standard error: 69.75 on 19 degrees of freedom
Multiple R-squared: 0.1265,	Adjusted R-squared: -0.01141 
F-statistic: 0.9173 on 3 and 19 DF,  p-value: 0.4513 
