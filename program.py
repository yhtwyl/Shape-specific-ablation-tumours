import re
import numpy as np
import difflib
from datetime import datetime 
def merge (l, r):
    m = difflib.SequenceMatcher(None, l, r)
    for o, i1, i2, j1, j2 in m.get_opcodes():
        if o == 'equal':
            yield l[i1:i2]
        elif o == 'delete':
            yield l[i1:i2]
        elif o == 'insert':
            yield r[j1:j2]
        elif o == 'replace':
            yield l[i1:i2]
            yield r[j1:j2]


def convert(sequence_):
    str1 = ""
    return(str1.join(sequence_))


def MergeMatchingSequences(AminoSequenceFinal_,AminoAcidPositionFinal_,QueryProteinFinal_,SubjectProteinFinal_):
    # PreviousLength = len(AminoSequenceFinal_)
    # MergedLength = 1
    # AminoSequenceFinal__ = list()
    # AminoAcidPositionFinal__ = list()
    # QueryProteinFinal__ = list()
    # SubjectProteinFinal__ = list()
    # sentinal_ = True
    # while sentinal_ == True:
    print('Merging Sequences')
    for i in range(len(AminoSequenceFinal_)): # -1
        MatchOccured = False
        WhatIsLeft = np.arange(i+1,len(AminoSequenceFinal_),1)
        for j in WhatIsLeft: #range(len(AminoSequenceFinal) - i):
            if (QueryProteinFinal_[i] == QueryProteinFinal_[j]) & (SubjectProteinFinal_[i] == SubjectProteinFinal_[j]) & ( (AminoAcidPositionFinal_[i]  + len(AminoSequenceFinal_[i]) - 1) == (AminoAcidPositionFinal_[j]  + len(AminoSequenceFinal_[j]) - 2)):
                AminoSequenceFinal_[j] = ''.join(merge(AminoSequenceFinal_[i], AminoSequenceFinal_[j]))
                AminoAcidPositionFinal_[j] = AminoAcidPositionFinal_[i]
                MatchOccured = True
        if MatchOccured == True:
            AminoSequenceFinal_[i] = '--'  
            QueryProteinFinal_[i] = '--'
            SubjectProteinFinal_[i] = '--'
    
    f1 = open('Merged.out','w+')
    for i in range(len(AminoAcidPositionFinal_)):
        f1.write("{} \t {} \t {} \t {} \n".format(AminoAcidPositionFinal_[i],AminoSequenceFinal_[i],QueryProteinFinal_[i],SubjectProteinFinal_[i]))
    f1.close()
    # for i in range(len(AminoSequenceFinal_) - 1):
    #     print(AminoAcidPositionFinal_[i],AminoSequenceFinal_[i],QueryProteinFinal_[i],SubjectProteinFinal_[i])
    
    # np.savetxt('Matched.out', (AminoSequenceFinal_,AminoAcidPositionFinal_,QueryProteinFinal_,SubjectProteinFinal_))  

start_time = datetime.now() 

QuerySequence = list()
QuerySequencePartial = list()
QuerySequenceProteinList = list()
NumberOfProteinsQuerySequence = 0
SubjectSequence = list()
SubjectSequencePartial = list()
SubjectSequenceProteinList = list()
AminoAcidPositionFinalMerged = list() # Amino Acid Position Final Adjacent Occurances Merged
AminoSequenceFinalMerged = list() # sequences merged
QueryProteinFinalMerged = list() 
SubjectProteinFinalMerged = list()
NumberOfProteinsSubjectSequence = 0
LengthOfAminoAcidChainToCompare = 9 # MINIMUM LENGTH OF AMINO ACID CHAIN
########################################################################################
##############################  QUERRY SEQUENCE  #######################################
########################################################################################
with open('uniprot-proteome_UP000001584+AND+(proteomecomponent_Chromosome).fasta') as f: # NAME OF THE QUERY SEQUENCE FILE. ('uniprot-proteome_UP000006731+AND+(proteomecomponent_Chromosome).fasta') as f:
    for line in f:
        if not (line.startswith('>')):
            QuerySequencePartial.append(line.rstrip())
        else:
            NumberOfProteinsQuerySequence+=1
            QuerySequence.append(convert(QuerySequencePartial))
            QuerySequencePartial = list()
            QuerySequenceProteinList.append(line)
print("NumberOfProteinsQuerySequence = ",NumberOfProteinsQuerySequence) # always one more than the actual number
##########################################################################################


with open('uniprot-proteome_UP000006731+AND+(proteomecomponent_Chromosome).fasta') as f: # NAME OF SUBJECT FILE
    for line in f:
        if not (line.startswith('>')):
            SubjectSequencePartial.append(line.rstrip())
        else:
            NumberOfProteinsSubjectSequence+=1
            SubjectSequence.append(convert(SubjectSequencePartial))
            SubjectSequencePartial = list()
            SubjectSequenceProteinList.append(line)
#print("NumberOfProteinsSubjectSequence = ",NumberOfProteinsSubjectSequence) # always one more than the actual number
#print("SubjectSequenceProteinList",SubjectSequenceProteinList)
#print(SubjectSequenceProteinList[NumberOfProteinsSubjectSequence-1])
#print(QuerySequence)
#print(SubjectSequence)

AminoAcidPositionFinal = list()
AminoSequenceFinal = list()
QueryProteinFinal = list()
SubjectProteinFinal = list()

AlphabetsSuccedingProteinNamesInQueryProtein = '>'
AlphabetsSuccedingProteinNamesInSubjectProtein = '>'
AlphabetsPrecedingProteinName = 'OS='
count_protein_query = -1
for QueryProtein in QuerySequence:
    count_protein_query+=1
    #    LengthOfQueryProtein = len(QueryProtein)
    print('QueryProtein number = ', count_protein_query)
    for i in range((len(QueryProtein) - (LengthOfAminoAcidChainToCompare - 1))):
        AminoAcidSequence = QueryProtein[i:i+LengthOfAminoAcidChainToCompare]
        count_protein_subject = -1 ###
        for protein in SubjectSequence:
            count_protein_subject+=1
            # Upto = len(protein) - (LengthOfAminoAcidChainToCompare - 1)
            BeginFrom = 0
            sentinal = True # The idea is that sentinal value will changed to False when there would be no match.
            UpperLimitOfSearchInProtein = len(protein) - LengthOfAminoAcidChainToCompare - 1
            while sentinal & (BeginFrom < UpperLimitOfSearchInProtein):
                match = protein[BeginFrom:].find(AminoAcidSequence) # Returns the first instance of match. So we change the length of string/protein over match is made.
                #print(match) I think we can loop over whole protein by using the length of protein and comparing it with the location returned by match.
                if not match == -1:
                    s1 = convert(QuerySequenceProteinList[count_protein_query - 1])
                    s2 = convert(SubjectSequenceProteinList[count_protein_subject -1])
                    AminoAcidPositionFinal.append(BeginFrom + match)
                    AminoSequenceFinal.append(AminoAcidSequence)
                    QueryProteinFinal.append(s1[s1.index(AlphabetsSuccedingProteinNamesInQueryProtein) + len(AlphabetsSuccedingProteinNamesInQueryProtein):s1.index(AlphabetsPrecedingProteinName)])
                    SubjectProteinFinal.append(s2[s2.index(AlphabetsSuccedingProteinNamesInSubjectProtein) + len(AlphabetsSuccedingProteinNamesInSubjectProtein):s2.index(AlphabetsPrecedingProteinName)])
                    BeginFrom = BeginFrom + match + LengthOfAminoAcidChainToCompare
                else:
                    sentinal = False
                    # print("I am having more than one term in protein subject sequence")

# with open('Unmatched.out', 'w') as out_file:
    # for i in range(len(AminoAcidPositionFinal)):
        # out_file.write(AminoAcidPositionFinal[i],'\t',AminoSequenceFinal[i],'\t',QueryProteinFinal[i],'\t',SubjectProteinFinal[i],'\n') 
f = open('Unmerged.out','w+') #
for i in range(len(AminoAcidPositionFinal)):
    f.write("{} \t {} \t {} \t {} \n".format(AminoAcidPositionFinal[i],AminoSequenceFinal[i],QueryProteinFinal[i],SubjectProteinFinal[i]))

f.close()
MergeMatchingSequences(AminoSequenceFinal,AminoAcidPositionFinal,QueryProteinFinal,SubjectProteinFinal)


time_elapsed = datetime.now() - start_time
print('Time elapsed (hh:mm:ss.ms) {}'.format(time_elapsed))

# print(AminoSequenceFinal,QueryProteinFinal,SubjectProteinFinal)
######### 
# for i in range(len(AminoSequenceFinal) - 1):
#      for j in np.arange(i+1,len(AminoSequenceFinal),1): #range(len(AminoSequenceFinal) - i):
#          if (QueryProteinFinal[i] == QueryProteinFinal[j]) & (SubjectProteinFinal[i] == SubjectProteinFinal[j]):#(AminoSequenceFinal[i] == AminoSequenceFinal[j]) & (QueryProteinFinal[i] == QueryProteinFinal[j]) & (SubjectProteinFinal[i] == SubjectProteinFinal[j]):
#             # print(i,j)
#             if ( AminoAcidPositionFinal[i] == (AminoAcidPositionFinal[j] - 1)):
#                 print(AminoSequenceFinal[i],AminoAcidPositionFinal[i],QueryProteinFinal[i],SubjectProteinFinal[i])
#                 print(AminoSequenceFinal[j],AminoAcidPositionFinal[j],QueryProteinFinal[j],SubjectProteinFinal[j]) 
#                 ''.join(merge(AminoSequenceFinal[i], AminoSequenceFinal[j]))
                    #                print(s2)
                # print(match, QueryProtein[i:i+LengthOfAminoAcidChainToCompare], s1[s1.index(AlphabetsSuccedingProteinNamesInQueryProtein) + len(AlphabetsSuccedingProteinNamesInQueryProtein):s1.index(AlphabetsPrecedingProteinName)], s2[s2.index(AlphabetsSuccedingProteinNamesInSubjectProtein) + len(AlphabetsSuccedingProteinNamesInSubjectProtein):s2.index(AlphabetsPrecedingProteinName)])
                # print(QueryProtein[i:i+LengthOfAminoAcidChainToCompare], s2[s2.index(AlphabetsSuccedingProteinName) + len(AlphabetsSuccedingProteinName):s2.index(AlphabetsPrecedingProteinName)])
                # print("Amino acid sequence",QueryProtein[i:i+LengthOfAminoAcidChainToCompare], "in Query protein",QuerySequenceProteinList[count_protein_query - 1] ,"located at = ", i, "matched in protein ",SubjectSequenceProteinList[count_protein_subject-1],"at = ",match)
                
# line_number = 0
# with open('uniprot-proteome_UP000001584+AND+(proteomecomponent_Chromosome).fasta') as f:
#     for line in f:
#         if (line.startswith('>')):
#             line_number+=1
#             if (line_number == (count_protein - 1)):
#

# for i in range(len(AminoAcidPositionFinal)):
#     for j in range(len(AminoAcidPositionFinal)):
#         if (not i == j) & (AminoAcidPositionFinal[i] == (AminoAcidPositionFinal[j] + 1)) & (QueryProteinFinal[i] == QueryProteinFinal[j]) & (SubjectProteinFinal[i] == SubjectProteinFinal[j]):
#             print(AminoAcidPositionFinal[i],'\t',AminoAcidPositionFinal[j],'\t', AminoSequenceFinal[i],'\t',AminoSequenceFinal[j],'\t',QueryProteinFinal[i], QueryProteinFinal[j],SubjectProteinFinal[i],SubjectProteinFinal[j])

