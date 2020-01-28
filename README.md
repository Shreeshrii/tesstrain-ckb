# tesstrain-ckb

Finetune Training and OCR evaluation of Tesseract 5.0.0 Alpha for Central Kurdish Sorani in Arabic script using
 [tesstrain Training workflow for Tesseract 4 as a Makefile](https://github.com/tesseract-ocr/tesstrain).

Certain file locations and scripts have been modified compared to source repos.

Since `ocrevalutf8 accuracy` is not able to handle large utf files, only a selection of data is used for evaluation using [UNLV OCR evaluation tools](https://github.com/Shreeshrii/ocr-evaluation-tools). Please also note that this does not correctly evaluate punctuation such as parenthesis and braces when used in RTL languages, so the accuracy results for (, ), [, ], etc are incorrect.

## Comparative Results

The following table has comparative results for the most used fonts for the _fast models from official repo 
and various finetuned models for Central Kurdish, using [lstmf files in list.eval](https://github.com/Shreeshrii/tesstrain-ckb/blob/master/data/ckb/list.eval)
which were not used for training.

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
| ckbLayer_1.661_152089_296500 	|                 	|       	|            	|        	|             	|
| ckbLayer_fast                  	| Accuracy        	| 98.20 	| 97.78      	| 98.06  	| 96.13       	|
| ckbLayer_fast                  	| Basic Arabic    	| 99.10 	| 99.15      	| 98.54  	| 98.44       	|
| ckbLayer_fast                  	| Arabic Extended 	| 98.30 	| 98.70      	| 99.10  	| 96.27       	|

## ckb - Central Kurdish/Sorani in Arabic script

Using 26 fonts, includes punctuation, AWN and AEN numbers.

* [Last three ckb models with lowest CER](https://github.com/Shreeshrii/tesstrain-ckb/tree/master/data/ckb/tessdata_fast)
