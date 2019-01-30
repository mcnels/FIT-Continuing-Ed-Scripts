#!/usr/bin/env ruby
require 'canvas-api'
require 'json'
require 'axlsx'
require 'date'

canvas = Canvas::API.new(:host => "https://fit.instructure.com", :token => "1059~c5Bnm7yge4gSWfeOJ9ZRtWCpGbUPwDkRQzXgV20CeMcA1j9wvEpXvlMrF3x9onyD")

# Get all courses
allCourses = canvas.get("/api/v1/accounts/8957/courses/")

while allCourses.more? do
  allCourses.next_page!
end
# puts allCourses
# Filter results for rbt courses only
numRBTcourses = 0
rbtCourses = Array.new
stuInfo = Array.new

allCourses.each do |course|
  if course['course_code'].to_s.include? "BEHP1196"
    numRBTcourses = numRBTcourses + 1
    rbtCourses.push(:id => course['id'], :name => course['name'])
  end
end

puts "There are #{numRBTcourses} RBT courses." # numRBTcourses
puts rbtCourses
puts "------------------------------------------------------------------------------------------------------"

# Get all the submissions for the precourse survey quizzes in all the rbt courses
# while saving the submission dates
numRBTquizzes = 0
precourseSurveyList = Array.new
rbtCourses.each do |course_id|
  puts "Current course: #{course_id[:id]}" # course_id[:id]
  # Get the quizzes in each rbt course
  quiz_list = canvas.get("/api/v1/courses/" + course_id[:id].to_s + "/quizzes", {'per_page' => '100'})

  # Get all the quizzes
  while quiz_list.more? do
    quiz_list.next_page!
  end

  quiz_list.each do |quiz|
    # Continue only if quiz is the precourse survey
    if (quiz['title'].to_s.include? "Precourse Survey") || (quiz['title'].to_s.include? "Pre-course Survey") || (quiz['title'].to_s.include? "Pre course Survey")
      numRBTquizzes = numRBTquizzes + 1
      precourseSurveyList.push(:id => quiz['id'], :coursename => course_id[:name], :title => quiz['title'])
      # puts quiz['id']

      # puts numRBTquizzes

      # Get all the submissions for the precourse survey
      submissions_list = canvas.get("/api/v1/courses/" + course_id[:id].to_s + "/quizzes/" + quiz['id'].to_s + "/submissions?", {'per_page' => '100'})
      while submissions_list.more? do
        submissions_list.next_page!
      end

      # Add submissions info to array of records for student
      submissions_list.each do |submission|

        unless submission['finished_at'].nil? # submission['finished_at'].to_s != "null" || submission['finished_at'].to_s != "null"
        # if submission['finished_at'].to_s != "null" || submission['finished_at'].to_s != "null"
          # puts submission['finished_at'].to_s

          # reminderDate = submission['finished_at'].to_s + 150
          # deadlineDate = submission['finished_at'].to_s + 180

          reminderDate = DateTime.parse(submission['finished_at'].to_s).to_date + 150
          deadlineDate = DateTime.parse(submission['finished_at'].to_s).to_date + 180

          stuInfo.push(:id => submission['user_id'], :sbmtime => submission['finished_at'].to_s, :reminder => reminderDate.to_s, :deadline => deadlineDate.to_s)
        #endif
        end
      #endsubmissions_list loop
      end
    #end if quiz_title
    end
  #end quiz_list loop
  end

puts "student info for #{course_id[:id]} named #{course_id[:name]}"
puts stuInfo
puts "There is information about #{stuInfo.length} students now."
puts "------------------------------------------------------------------------------------------------------"
#end courses loop
end

#remove duplicates
stuInfo.uniq! { |stu| stu[:id] }

puts "There is information about #{stuInfo.length} students in total."
puts "------------------------------------------------------------------------------------------------------"

# Get deactivation list
deactivation = Array.new
reminder = Array.new
stuInfo.each do |st|
  if (Date.today == DateTime.parse(st[:deadline].to_s).to_date) #|| (Date.parse(st[:deadline].to_s).past?)
  # if (Date.today - DateTime.parse(st[:deadline].to_s).to_date) <= 0
    deactivation.push(:id => st[:id], :sbmtime => st[:sbmtime].to_s, :deadlineDay => st[:deadline].to_s)
  end

  if (Date.today == DateTime.parse(st[:reminder].to_s).to_date) #|| (Date.parse(st[:reminder].to_s).past?)
    reminder.push(:id => st[:id], :sbmtime => st[:sbmtime].to_s, :reminderDay => st[:reminder].to_s)
    # send names to abareg, jenn and steph
    canvas.post("/api/v1/conversations", {'recipients[]=' => ['1010887', '1842270', '1874990'], 'subject=' =>'RBT 150 day reminder', 'body=' => reminder[:id].to_s+' \n' })
  end
end

#test
puts "There are #{reminder.length} students to remind today."
puts reminder
puts "------------------------------------------------------------------------------------------------------"
puts "There are #{deactivation.length} students to deactivate today."
puts deactivation
puts "------------------------------------------------------------------------------------------------------"

# isDeactivated = false
#
# deactivation.each do |deact|
#   if deact[:status].to_s == "active"
#     canvas.delete("/api/v1/courses/533396/enrollments/" + deact[:enroll].to_s, {'task' =>'inactivate'})
#     isDeactivated = true
#     # send message to abareg, Jenn, Stephanie and Marisell (1873108)
#     # canvas.post("/api/v1/conversations", {'recipients[]=' =>'1010887', 'recipients[]=' =>'1842270', 'recipients[]=' =>'1874990', 'recipients[]=' =>'1873108', 'subject=' =>'RBT Idaho deactivated student', 'body=' => deact[:name].to_s+' \n' })
#     canvas.post("/api/v1/conversations", {'recipients[]=' => ['1010887', '1842270', '1874990', '1873108'], 'subject=' =>'RBT Idaho Deactivations', 'body=' => deact[:name].to_s+' \n' })
#     puts deact[:name].to_s + " deactivated!"
#   end
# end
#
# if isDeactivated == false
#   # canvas.post("/api/v1/conversations", {'recipients[]=' => ['1010887', '1842270', '1588479'], 'subject=' =>'RBT Idaho Deactivations', 'body=' => 'test \n' })
#   puts "No deactivations today!"
# end

puts "All done!"
