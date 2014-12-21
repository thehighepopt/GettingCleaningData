README.md for run_analysis script

The code is fairly basic, like my R skills

The initial part which is commented out sets up the file in your directory and upacks the zip file, then resets your working directory to have access to the upacked data.

The next two lines pulls in the variable names from features.txt and the activities names, which I treat as a lookup table a la rdbs, in preparation for later use.  I think I could incorporate headers into later code and remove it here,  but won't.

through rbind I put the two test and train files together, then to determine which variables to keep, I create keepers and use that in a subset 'select' argument, fixed = TRUE is wonderful.

with now just the Mean and Std columns in the dataset, I combine the test and train sets for subject and activity separately, then cbind those to the full data set created before.  

because we need to have actual Activity names, I then merge the earlier lookup file I created with the latest dataframe, which gives a total of 69 columns and 10,000+ rows.  This is the final data set and gets through steps 1-4 of the project

Step 5 is next, using dplyr, I turn the final data into a table, group by activity and subject, the apply mean to each of the fields in the dataframe using summarise_each, and arrange it for neatness.  T

Then it's just a matter of writing a table as a text file
