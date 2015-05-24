

subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
labels <- read.table("UCI HAR Dataset/test/y_test.txt")
features <- read.table("UCI HAR Dataset/test/X_test.txt")
dataSetTest <- cbind(subjects, labels, features)

subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
labels <- read.table("UCI HAR Dataset/train/y_train.txt")
features <- read.table("UCI HAR Dataset/train/X_train.txt")
dataSetTrain <- cbind(subjects, labels, features)

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityIdentifier", "activityName"))
featureNames <- read.table("UCI HAR Dataset/features.txt", col.names = c("featureIdentifier", "featureName"))

dataSetMerged <- rbind(dataSetTrain, dataSetTest)
featureNamesAsString <- as.character(featureNames[, 2])
colnames(dataSetMerged) <- c("subjectIdentifier", "labelIdentifier", featureNamesAsString)

columnNames <- colnames(dataSetMerged)
featureNames <- columnNames[3:length(columnNames)]

## Remove feature columns which are not mean or std()
pattern <- "(mean|std\\(\\))"
validFeatures <- grepl(pattern, featureNames, ignore.case = T)
dataSetMerged <- dataSetMerged[, c(c(T, T), validFeatures)]

# Fix labels
fixedDataSet <- merge(dataSetMerged, activityLabels, by.x = "labelIdentifier", by.y = "activityIdentifier", all = T)
fixedDataSet <- fixedDataSet[, !(names(fixedDataSet) %in% c("activityIdentifier", "labelIdentifier"))]

tidy <- ddply(fixedDataSet, .(activityName, subjectIdentifier), numcolwise(mean))

columnNames <- tolower(colnames(tidy))
normalizedFeatureNames <- gsub("(mean\\(\\))", "mean", columnNames[3:length(columnNames)])
normalizedFeatureNames <- gsub("(std\\(\\))", "std", normalizedFeatureNames)
normalizedFeatureNames <- gsub("(\\(|\\)|-|,|_)", "", normalizedFeatureNames)

normalizedFeatureNames <- vapply(normalizedFeatureNames, function (name) { paste0(name, "average") }, FUN.VALUE = character(1))
colnames(tidy) <- c(columnNames[1:2], normalizedFeatureNames)

write.table(tidy, file = "tidy.out", row.names = F)
