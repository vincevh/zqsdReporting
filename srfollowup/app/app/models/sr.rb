class Sr < ActiveRecord::Base

    def self.getPrevious(userid)
        Sr.where("userid = #{userid}").order("id DESC").find(1)
    end    
end