class Vote < ActiveRecord::Base
validates_presence_of :restaurant_id, :user_id
belongs_to :restaurant
belongs_to :user

 def self.deleteOldVotes(votes)
    votes.each do |existingVote|
      isToday = Vote.isToday(existingVote)
      if(not isToday)
        votes.delete(existingVote)
      end
    end
    return votes
  end
 
  def self.isToday(vote)
  	return (vote.created_at - Time.today) > 0
#	return (Time.now - vote.created_at) < 60
  end
end
