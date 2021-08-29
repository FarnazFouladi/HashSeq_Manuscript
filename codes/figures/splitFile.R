splitFile <- function(inputFile,  num_of_splits  = 2 , outputDirName='output_split')
{
  # Splits the contents of the inputFile into at least the number of files specified by num_of_splits
  # Example invocation
  # splitFile(inputFile="absolute_file_path/OneMismatchCluster_Vaginal.txt", num_of_splits = 5, outputDirName = "split_onemismatchcluster")
 
  if(!file.exists(inputFile))
  {
    stop(paste0("Input file does not exist: ", inputFile))
  }

  fileName <- basename(inputFile)
  source_directory <- dirname(inputFile)
  outputDirPath <- file.path(source_directory, outputDirName)
  connection <- file(inputFile)
  num_of_output_files <- 0
  open(connection)
  
  # Calculate total number of lines within source file
  current_line <- readLines(connection, n=1)
  total_lines <- 1
  while(length(current_line) > 0) 
    {
      current_line <- readLines(connection, n=1)
      if(length(current_line) > 0)
      {
        total_lines <- total_lines + 1
      }
  }
  
  seek(connection, 0)
  file_indices <- sprintf('%03d', seq(num_of_splits))
  num_of_lines_per_file <- total_lines %/% num_of_splits
  left_over_lines <- total_lines %% num_of_splits
  
  if(!dir.exists(outputDirPath))
  {
    dir.create(outputDirPath)
  }
 
  write_file <- function(fileNameWithExtension, file_connection, index, num_of_lines)
  {
    current_file_name <- paste0(unlist(strsplit(fileNameWithExtension, "\\."))[1], "_", index, ".", unlist(strsplit(fileNameWithExtension, "\\."))[2])
    current_file_name_path <- file.path(outputDirPath, current_file_name)
    sink(current_file_name_path)
    for (j in 1:num_of_lines)
    {
      line <- readLines(file_connection, n=1)[1]
      if(length(line) > 0)
      {
        cat(line)
        cat("\n")
      }
      else
      {
        break
      }
    }
    sink()
  }
  
  for (i in file_indices)
  {
    write_file(fileName, connection, i, num_of_lines_per_file)
  }
  
  if(left_over_lines > 0)
  {
    final_index <- sprintf('%03d', length(file_indices) + 1)
    write_file(fileName, connection, final_index, left_over_lines)
  }
  
  close(connection)
  
  if (num_of_lines_per_file > 0)
  {
    num_of_output_files <- num_of_splits
  }
  if(left_over_lines > 0 )
  {
    num_of_output_files <- num_of_output_files + 1
  }
  
  print(paste0("Total number of output files: ",num_of_output_files))
  print(paste0("Output file set directory: ",outputDirPath))
  print(paste0("Total number of lines within input file ",inputFile, ': ', total_lines))
  print(paste0("Number of lines within each main file: ", num_of_lines_per_file))
  print(paste0("Number of lines within the remainder file: ", left_over_lines))
}