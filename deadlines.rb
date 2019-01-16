#!/usr/bin/env ruby
require 'canvas-api'
require 'json'
require 'axlsx'
require 'date'

canvas = Canvas::API.new(:host => "https://fit.instructure.com", :token => "1059~YUDPosfOLaWfQf4XVAsPavyXFYNjGnRHzqSbQuwFs6eQDANaeShDaGPVEDufVAEj")

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
# rbtCoursesNames = Array.new
allCourses.each do |course|
  if course['course_code'].to_s.include? "BEHP1196"
    numRBTcourses = numRBTcourses + 1
    rbtCourses.push(:id => course['id'], :name => course['name'])
    # rbtCoursesNames.push(course['name'])
  end
end

# puts numRBTcourses
puts rbtCourses

# Get all the submissions for the precourse survey quizzes in all the rbt courses
# while saving the submission dates
numRBTquizzes = 0
precourseSurveyList = Array.new
rbtCourses.each do |course_id|
  puts course_id[:id]
  # Get the quizzes in each rbt course
  quiz_list = canvas.get("/api/v1/courses/" + course_id[:id].to_s + "/quizzes", {'per_page' => '100'})

  # Get all the quizzes
  while quiz_list.more? do
    quiz_list.next_page!
  end

  quiz_list.each do |quiz|
    # Continue only if quiz is the precourse survey
    if (quiz['title'].to_s.include? "Precourse Survey") || (quiz['title'].to_s.include? "Pre-course Survey")
      numRBTquizzes = numRBTquizzes + 1
      precourseSurveyList.push(:id => quiz['id'], :coursename => course_id[:name], :title => quiz['title'])
      # puts quiz['id']

      puts numRBTquizzes

      # Get all the submissions for the precourse survey
      submissions_list = canvas.get("/api/v1/courses/" + course_id[:id].to_s + "/quizzes/" + quiz['id'].to_s + "/submissions?", {'per_page' => '100'})
      while submissions_list.more? do
        submissions_list.next_page!
      end

      # Add submissions info to array of records for student
      submissions_list.each do |submission|

        if submission['finished_at'] != "null"
          puts submission['finished_at'].to_s

          # reminderDate = submission['finished_at'].to_s + 150
          # deadlineDate = submission['finished_at'].to_s + 180

          reminderDate = DateTime.parse(submission['finished_at'].to_s).to_date + 150
          deadlineDate = DateTime.parse(submission['finished_at'].to_s).to_date + 180

          stuInfo.push(:id => submission['user_id'], :sbmtime => submission['finished_at'].to_s, :reminder => reminderDate.to_s, :deadline => deadlineDate.to_s)


        end
      end


        # if student['id'].to_s == submission['user_id'].to_s #&& (submission['started_at'] != "null" || submission['finished_at'] != "null")
        #   currstudent = student['sortable_name'] # might need to change this to username
        #   break if submission['started_at'].nil? || submission['finished_at'].nil?
        #
        #   # Print to console
        #   puts currstudent+" started"
        #   stuRec[i][j] = {:stime => submission['started_at'], :sbmtime => submission['finished_at'], :unit => q['title']}
        #   tookTest = "Y"
        #   break if tookTest == "Y"
        # end







    end
  end

puts stuInfo

end

# puts precourseSurveyList
puts stuInfo

# calculate 150 days from the submission date, save it under "reminder" column


# calculate 180 days from the submission date, save it under "180 completed" column


# if today >= 180 days since a user has submitted the survey, then deactivate them in the course
# (enrollment api endpoint: DELETE /api/v1/courses/:course_id/enrollments/:id)


# Notify abareg of who needs to be remided of the deadline and who's been deactivated (conversations api endpoint)


#
