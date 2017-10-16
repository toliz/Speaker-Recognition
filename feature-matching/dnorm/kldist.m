function KL = kldist(speaker, world, N)
%KL = KLDIST(speaker, world, N) estimates the Kullback Leibler distance of 
%the speaker and the world model
% 
%Inputs:
%   - speaker : a struct containing the gmm for a particular speaker
%   - world   : the universal background model
%   - N       : number of samples for synthetic data
%
%Outputs:
%   - KL	  : the Kullback Leibler distance between speaker and world model

nDist   = size(speaker.mu, 2);
nPoints = ceil(speaker.w * N);

speakerPoints = [];
worldPoints   = [];
for k = 1:nDist  
    speakerPoints = [speakerPoints; mvnrnd(speaker.mu(:, k), speaker.sigma(:, k)', nPoints(k))];
    worldPoints   = [worldPoints;   mvnrnd(world.mu(:, k),   world.sigma(:, k)',   nPoints(k))];
end

KL_speaker = mean(llk(speakerPoints, speaker) - llk(speakerPoints, world));
KL_world   = mean(llk(worldPoints, world)     - llk(worldPoints, speaker));

KL = KL_speaker + KL_world;

end
