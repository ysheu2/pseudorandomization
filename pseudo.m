%% Create a matrix with trials in a pseudorandomized order. 
% You can control for number of stimulus and/or response repetitions in an
% experiment.  For example, in this 2x2 factorial design, we have two
% factors (word congruency and cue congruency) in this task, each with two
% levels; and we want to keep equal numbers of task switch/repeat and
% left/right button response for each condition.  

% Note that: numTrials must be multiplication of the number of elements in combo (eg 8 elements, numTrial must be 16,32,64...)

function structure = pseudo(numTrials,numBlocks)

structure = cell(numTrials,numBlocks);

%% modify this part to fit your experiment design.
A = [1 1 1]; %conCue, conWord, leftkey
B = [1 1 2]; %conCue, conWord, rightkey
C = [1 2 1]; %conCue, inconWord, leftkey
D = [1 2 2]; %ConCue, inconWord, rightkey
E = [2 1 1]; %inconCue, conWord, leftkey
F = [2 1 2]; %inconCue, conWord, rightkey
G = [2 2 1]; %inconCue, inconWord, leftkey
H = [2 2 2]; %inconCue, inconWrod, rightkey

% automatically generates a list of combo based on numTrials (each letter represents a
% condition)
combo={A B C D E F G H}';
rep=numTrials/length(combo);
combo=repmat(combo,rep);

wordcueCongruency = zeros(numTrials,numBlocks);%whether the displayed word has the same button response regardless which task is being performed
cueCongruency = zeros(numTrials,numBlocks); %whehter the displayed cue is a congruent vs incongruent cue
numSwitch = zeros(numTrials,numBlocks);
decision_mat = zeros(numTrials,numBlocks);

for j = 1:numBlocks
    check = 1;
    while (check > 0)
        structure(:,j) = combo(randperm(length(combo)));
        for i = 1:numTrials
            if i~=1 % exclude the first trial, because there is no switch/repeat task for the first trial
                numSwitch(i,j) = structure{i,j}(3) ~= structure{i-1,j}(3); %3th element is left/right resp, here it calculates the number of task switch across trials
            end
            cueCongruency(i,j) = structure{i,j}(1) == 1;
            wordcueCongruency(i,j) = structure{i,j}(2) == 1;
        end
        
        numSwitch = double(numSwitch);
        cueCongruency = double(cueCongruency);
        wordcueCongruency = double(wordcueCongruency);
        decision = numSwitch(:,j)+ 2*(cueCongruency(:,j)) + 4*(wordcueCongruency(:,j)); %total of 8 (2*2*2) outcome (switch/repeat, congruent/incongruent cues, congruent/incongruent word)
        dec0 = (decision == 0);
        dec1 = (decision == 1);
        dec2 = (decision == 2);
        dec3 = (decision == 3);
        dec4 = (decision == 4);
        dec5 = (decision == 5);
        dec6 = (decision == 6);
        dec7 = (decision == 7);
        if sum(dec0) == rep && sum(dec1) == rep && sum(dec2) == rep && sum(dec3) == rep && sum(dec4) == rep && sum(dec5) == rep && sum(dec6) == rep && sum(dec7) == rep
            check = 0; 
        end
    end
    decision_mat(:,j) = decision;
end
