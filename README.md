# tesstrain-ckb

Finetune Training and OCR evaluation of Tesseract 5.0.0 Alpha for Central Kurdish Sorani in Arabic script using
 [tesstrain Training workflow for Tesseract 4 as a Makefile](https://github.com/tesseract-ocr/tesstrain).

Certain file locations and scripts have been modified compared to source repos.

Since `ocrevalutf8 accuracy` is not able to handle large utf files, only a selection of data is used for evaluation using [UNLV OCR evaluation tools](https://github.com/Shreeshrii/ocr-evaluation-tools). Please also note that this does not correctly evaluate punctuation such as parenthesis and braces when used in RTL languages, so the accuracy results for (, ), [, ], etc are incorrect.

## Comparative Results

The following table has comparative results for the list.eval set of lstmf files for the _fast models from official repo and various finetuned models for Central Kurdish.

|                                   	|                 	| Arial 	| Arial Bold 	| Tahoma 	| Tahoma Bold 	|
|-----------------------------------	|-----------------	|------:	|-----------:	|-------:	|------------:	|
| tessdata_fast/ara                 	| Accuracy        	| 62.53 	|      63.22 	|  62.45 	|       59.28 	|
| tessdata_fast/ara                 	| Basic Arabic    	| 93.02 	|      94.39 	|  94.17 	|       89.07 	|
| tessdata_fast/ara                 	| Arabic Extended 	|  0.81 	|       0.72 	|   0.73 	|        0.74 	|
|                                   	|                 	|       	|            	|        	|             	|
| tessdata_fast/script/Arabic       	| Accuracy        	| 80.84 	|      80.72 	|  80.19 	|       74.75 	|
| tessdata_fast/script/Arabic       	| Basic Arabic    	| 93.75 	|      93.90 	|  91.37 	|       86.38 	|
| tessdata_fast/script/Arabic       	| Arabic Extended 	| 62.72 	|      61.85 	|  65.30 	|       57.65 	|
|                                   	|                 	|       	|            	|        	|             	|
| ckb100Layer_fast                  	| Accuracy        	| 84.35 	|      85.66 	|  85.72 	|       82.11 	|
| ckb100Layer_fast                  	| Basic Arabic    	| 89.20 	|      89.47 	|  89.59 	|       86.03 	|
| ckb100Layer_fast                  	| Arabic Extended 	| 94.53 	|      95.30 	|  95.28 	|       90.24 	|
|                                   	|                 	|       	|            	|        	|             	|
| ckbnew100Layer_fast               	| Accuracy        	| 87.50 	|      87.87 	|  88.46 	|       85.09 	|
| ckbnew100Layer_fast               	| Basic Arabic    	| 89.68 	|      89.49 	|  90.28 	|       86.82 	|
| ckbnew100Layer_fast               	| Arabic Extended 	| 94.44 	|      95.05 	|  95.43 	|       90.50 	|
|                                   	|                 	|       	|            	|        	|             	|
| ckballLayer_3.902_122431_261300 	|                 	|       	|            	|        	|             	|
| ckballLayer_fast                  	| Accuracy        	| 91.97 	| 92.31      	| 91.78  	| 88.85       	|
| ckballLayer_fast                  	| Basic Arabic    	| 95.68 	| 95.85      	| 95.70  	| 92.25       	|
| ckballLayer_fast                  	| Arabic Extended 	| 98.55 	| 98.54      	| 97.34  	| 94.09       	|

## ckballfonts - Central Kurdish/Sorani in Arabic script

Using approximately 40 fonts, using punctuation, AWN and AEN numbers.

* [ckballfontsLayer_fast]()

## ckball - Central Kurdish/Sorani in Arabic script

Only Arial and Tahoma fonts, using punctuation, AWN and AEN numbers.

* [ckballLayer_fast]()

## Other Central Kurdish/Sorani in Arabic script Finetuned Traineddata files

Only Arial and Tahoma fonts, using a limited unicharset

* [ckb100Layer_fast - No punctuation or Numbers](https://github.com/Shreeshrii/tesstrain-ckb/blob/master/data/ckb100Layer_fast.traineddata)
* [ckbnew100Layer_fast - Some punctuation No Numbers](https://github.com/Shreeshrii/tesstrain-ckb/blob/master/data/ckbnew100Layer_fast.traineddata)
