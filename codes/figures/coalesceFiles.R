## ---------------------------
##
## Script name: coalesceFiles
##
## Purpose of script: Merging splits of OneMismatchCluster for vaginal and china datasets.
##                    These files are large so their splits have been saved in the github repo.
##
## Author: Jacqueline B. Young
##
## Date Created: 2021-08-29
##
## ---------------------------

#*********************Functions***********************
coalesceFiles <- function(inputDir,outputDir ,prefix)
{
  # Combines a set of files, with the specified prefix, within a directory specified by inputDir.
  # Example invocation
  # coalesceFiles(inputDir = 'absolute_directory_path/directory_name',outputDir ,prefix='OneMismatchCluster')

  if (!dir.exists(inputDir))
  {
    stop(paste0('Input directory does not exist: ', inputDir))
  }

  fileSet <- list.files(inputDir, paste0('^', prefix, '*'))
  fileSet <- sort(fileSet)
  if(length(fileSet) == 0)
  {
    stop(paste0('Input directory (', inputDir, ') does not contain any files that begin with ', '\'', prefix, '\''))
  }

  outputFilePath <- file.path(outputDir, paste0(prefix, ".txt"))
  sink(outputFilePath)
  input_file_paths <- vector()

  # Iterate through each file for subsequent integration
  for (fileName in fileSet)
  {
    current_file_path <- file.path(inputDir, fileName)
    input_file_paths <- append(input_file_paths, current_file_path)
    connection <- file(current_file_path)
    open(connection)
    current_line <- readLines(connection, n=1)
    while(length(current_line) > 0)
    {
      if(length(current_line) > 0)
      {
        cat(current_line)
        cat("\n")
      }
      else
      {
        break
      }
      current_line <- readLines(connection, n=1)

    }
    close(connection)
  }

  sink()
  cat(paste0('Combined output file path: ', '\n', outputFilePath))
  cat('\n\n')
  print(paste0('Number of input files: ', length(fileSet)))
  for (filePath in input_file_paths)
  {
    print(filePath)
  }
}

#*********************Merging files***********************
coalesceFiles(inputDir = 'data/vaginal/split_onemismatchcluster',outputDir = 'data/vaginal' ,prefix='OneMismatchCluster')
coalesceFiles(inputDir = 'data/china/split_onemismatchcluster',outputDir = 'data/china' ,prefix='OneMismatchCluster')
