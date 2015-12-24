read_input_data=function(){
  df.features=read.table('./features.txt',header=F); 
  df.activitylabels=read_table('./activity_labels.txt',col_names=F); 
  #read training data
  df.train.subjectid=read_table('./train/subject_train.txt',col_names=F);  
  df.train.x=read_table('./train/x_train.txt',col_names=F);
  df.train.y=read_table('./train/y_train.txt',col_names=F);
  
  #read test data
  df.test.subjectid=read_table('./test/subject_test.txt',col_names=F); 
  df.test.x=read_table('./test/x_test.txt',col_names=F);  
  df.test.y=read_table('./test/y_test.txt',col_names=F);
  #assign colnames
  colnames(df.train.x)<-df.features[,ncol(df.features)]
  colnames(df.train.y)<-"activity_id"
  colnames(df.train.subjectid)<-"subject_id"
  colnames(df.test.x)<-df.features[,ncol(df.features)]
  colnames(df.test.y)<-"activity_id"
  colnames(df.test.subjectid)<-"subject_id"
  
  #create 1 training set
  df.train.merged<-bind_cols(df.train.subjectid,df.train.x,df.train.y)
  
  #create 1 test set
  df.test.merged<-bind_cols(df.test.subjectid,df.test.x,df.test.y)
  
  #merge training and test set
  df.merged<-rbind(df.train.merged,df.test.merged)
  return(df.merged)
}
select_columns=function(mydf){
  columns_to_keep<-which(grepl("subject_id", names(mydf), ignore.case=TRUE)==TRUE | grepl("activity_id", names(mydf), ignore.case=TRUE)==TRUE | grepl("[Mm]ean", names(mydf), ignore.case=TRUE)==TRUE | grepl("std", names(mydf), ignore.case=TRUE)==TRUE)
  return(mydf[,columns_to_keep])
}
label_columns=function(mydf){
  df.activitylabels=read_table('./activity_labels.txt',col_names=F);
  colnames(df.activitylabels)<-c("activity_id","activity_description")
  mynewdf<-merge(mydf,df.activitylabels,by="activity_id",all.x=T,all.y=F)
  
  #now make descriptive activity names
  column.names<-colnames(mynewdf)
  for(i in 1:length(column.names)){
    column.names[i] = gsub("\\()","",column.names[i]) 
    column.names[i] = gsub("std()","StdDev",column.names[i]) 
    column.names[i] = gsub("-mean","Mean",column.names[i]) 
    column.names[i] = gsub("^(t)","time_",column.names[i]) 
    column.names[i] = gsub("^(f)","freq_",column.names[i]) 
    column.names[i] = gsub("([Gg]ravity)","Gravity",column.names[i]) 
    column.names[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",column.names[i]) 
    column.names[i] = gsub("[Gg]yro","_Gyroscope_",column.names[i])
    column.names[i] = gsub("Acc","_Acceleration_",column.names[i])
    column.names[i] = gsub("JerkMean","Jerk_Mean",column.names[i])
    column.names[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",column.names[i]) 
    column.names[i] = gsub("Mag","Magnitude",column.names[i])
    column.names[i] = gsub("MagnitudeMean","Magnitude_Mean",column.names[i])
    column.names[i] = gsub("-StdDev","_StdDev",column.names[i])
    column.names[i] = gsub("_-","_",column.names[i])
    column.names[i] = gsub("__","_",column.names[i])
    column.names[i] = gsub("-","_",column.names[i])
  }
  colnames(mynewdf)<-column.names
  return(mynewdf)
}
calculate_mean_for_column=function(data=NULL, measurevar, groupvars=NULL){
  datac <- ddply(data, groupvars,
                 .fun = function(xx, col) {
                     mean = mean(xx[[col]])
                 },
                 measurevar
  )
  return(datac)
}
produce_mean=function(mydf){
  #reorder columns to ensure that activity_description is not the last one
  mydf<-select(mydf,subject_id,activity_id,activity_description,3:(ncol(mydf)-1))
  for(i in 4:ncol(mydf)){
    tmp<-calculate_mean_for_column(mydf,colnames(mydf)[i],c("subject_id","activity_description"))
    if(i==4){
      aggregate<-tmp
    }else{
      aggregate<-cbind(aggregate,tmp[,ncol(tmp)])
    }
    colnames(aggregate)[ncol(aggregate)]<-colnames(mydf)[i]
  }
  return(aggregate)
}
main=function(){
  #Start from empty workspace
  rm(list=ls())
  if(!require(readr))install.packages("readr")
  if(!require(dplyr))install.packages("dplyr")
  if(!require(plyr))install.packages("plyr")
  
  setwd("C://Users/mwauters/Documents/Private/coursera/Cleaning data/assignment/")
  
  #read input data and merge training and test set
  df.merged<-read_input_data() 
  #select relevant columns
  df.merged.filtered<-select_columns(df.merged)
  #rename columns
  df.merged.filtered<-label_columns(df.merged.filtered)
  #produce mean
  df.final<-produce_mean(df.merged.filtered)
  
  write.table(df.final,file="./getting_and_cleaning_data/tidy.txt",sep="\t",row.names=F,col.names=T)
  return(df.final)
  }
df.final<-main()

