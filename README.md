# tesstrain-ckb

Finetune Training and OCR evaluation of Tesseract 5.0.0 Alpha for Central Kurdish Sorani in Arabic script using
 [tesstrain Training workflow for Tesseract 4 as a Makefile](https://github.com/tesseract-ocr/tesstrain). 
Certain file locations and scripts have been modified compared to source repos.

OCR evaluation is done using [ISRI Analytic Tools for OCR Evaluation with UTF-8 support](https://github.com/eddieantonio/ocreval). 

## ckb - Central Kurdish/Sorani in Arabic script

Replace the top layer training is being done using [26 fonts](https://github.com/Shreeshrii/tesstrain-ckb/blob/master/langdata/ckb.fontslist.txt). The [training text](https://github.com/Shreeshrii/tesstrain-ckb/blob/master/langdata/ckb.training_text) includes punctuation, AWN and AEN numbers. Fonts used do not include those which convert 0-9 to either Arabic or Persian numbers.

Currently the training data includes:
* AWN 0-9
* AEN - Arabic numbers
* No Persian numbers since some shapes are similar to Arabic Numbers

The replace top layer training is still ongoing. The eval results look much better than the official ara or script/Arabic.

General punctuation (parenthesis, brackets, etc.) is reported as having accuracy of 0.0% after training - this needs to be further investigated (is it error in evaluation tools or problem when reversing the RTL text for box files?)

## Comparative Results

The following table has comparative results for the most used fonts for the _fast models from official repo 
and various finetuned models for Central Kurdish, using lstmf files in list.eval which are different from those used for training.

[Reports with additional details for all fonts are also available.](https://github.com/Shreeshrii/tesstrain-ckb/tree/master/reports)

|                                   	|                 	| Arial 	| Arial Bold 	| Tahoma 	| Tahoma Bold 	|
| Official Models --------------	|-----------------	|------:	|-----------:	|-------:	|------------:	|
|                                   	|                 	|       	|            	|        	|             	|
| tessdata_fast/ara                 	| Accuracy        	| 62.74 	|      63.49 	|  61.56 	|       61.71 	|
| tessdata_fast/ara                 	| Basic Arabic    	| 95.68 	|      95.22 	|  95.76 	|       94.10 	|
| tessdata_fast/ara                 	| Arabic Extended 	|  0.31 	|       1.13 	|   0.41 	|        1.32	|
|                                   	|                 	|       	|            	|        	|             	|
| tessdata_fast/script/Arabic       	| Accuracy        	| 80.99 	|      80.83 	|  83.02 	|       77.17 	|
| tessdata_fast/script/Arabic       	| Basic Arabic    	| 96.68 	|      96.34 	|  96.05 	|       93.87 	|
| tessdata_fast/script/Arabic       	| Arabic Extended 	| 57.20 	|      58.23 	|  63.76 	|       54.72 	|
|                                   	|                 	|       	|            	|        	|             	|
| Finetuned Models          	|                 	|       	|            	|        	|             	|
|                                   	|                 	|       	|            	|        	|             	|
| ckbLayer_1.661_152089_296500 	|                 	|       	|            	|        	|             	|
| ckbLayer_fast                  	| Accuracy        	| 98.20 	| 97.78      	| 98.06  	| 96.13       	|
| ckbLayer_fast                  	| Basic Arabic    	| 99.10 	| 99.15      	| 98.54  	| 98.44       	|
| ckbLayer_fast                  	| Arabic Extended 	| 98.30 	| 98.70      	| 99.10  	| 96.27       	|
|                                   	|                 	|       	|            	|        	|             	|
| ckbLayer_1.413_255615_562800 	|                 	|       	|            	|        	|             	|
| ckbLayer_fast                  	| Accuracy        	| 98.30 	| 97.89      	| 98.25  	| 96.13       	|
| ckbLayer_fast                  	| Basic Arabic    	| 99.40 	| 99.29      	| 99.65  	| 98.40       	|
| ckbLayer_fast                  	| Arabic Extended 	| 98.30 	| 98.70      	| 99.34  	| 96.27       	|
|                                   	|                 	|       	|            	|        	|             	|
