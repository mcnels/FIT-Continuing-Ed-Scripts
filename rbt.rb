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

  list_student = canvas.get("/api/v1/courses/" + course_id[:id].to_s + "/enrollments", {'type' =>'StudentEnrollment'})
  while list_student.more? do
    list_student.next_page!
  end

  students = Array.new(list_student)

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

      # Get all the submissions for the precourse survey
      submissions_list = canvas.get("/api/v1/courses/" + course_id[:id].to_s + "/quizzes/" + quiz['id'].to_s + "/submissions?", {'per_page' => '100'})
      while submissions_list.more? do
        submissions_list.next_page!
      end

      # Add submissions info to array of records for student
      submissions_list.each do |submission|
        # skip Barbara Metzgder
        next if submission['user_id'].to_s == '1870970'

        unless submission['finished_at'].nil?
          found = false

          # Calculate reminder and deadline dates
          reminderDate = DateTime.parse(submission['finished_at'].to_s).to_date + 150
          deadlineDate = DateTime.parse(submission['finished_at'].to_s).to_date + 181

          students.each do |stu|
            if stu['user_id'].to_s == submission['user_id'].to_s
              found = true
              stuInfo.push(:enrollID => stu['id'], :id => submission['user_id'], :name => stu['user']['name'], :course => course_id[:id], :sbmtime => submission['finished_at'].to_s, :reminder => reminderDate.to_s, :deadline => deadlineDate.to_s)
            end
            break if found
          #endstudentsloop
          end
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

# messages to send to Students
message = "Hello, \n"+"\n"
message += "We are writing to remind you that the 40-hour RBT Training course must be completed within 180 days. This is a requirement set by the Behavior Analyst Certification Board. The board will not accept your coursework if it is not completed within 180 days.\n"+"\n"
message += "Students who do not complete the course within 180 days will be required to register and pay for the course a second time and begin the course anew, should they still want to pursue the RBT credential.\n"+"\n"
message += "We have determined that you are approaching the last 30 days of the 180-day course limit. Please be sure to complete the course as soon as possible so you do not forfeit the work you have already done in the course.\n"+"\n"
message += "Please let us know if you have any questions or concerns. You can contact us by emailing abareg@fit.edu or calling 1-321-674-8382, option 2. We're available by phone from 9:00 AM to 5:00 PM Eastern time Monday through Friday, excluding university holidays.\n"+"\n"


message2 = "Hello, \n"+"\n"
message2 += "Unfortunately, your access to the RBT Essentials course has expired. The BACB requires that the 40-hour RBT training must be completed within 180 days. If you still wish to complete the course, you will need to repurchase it and start over from the beginning.\n"+"\n"
message2 += "To reregister for the RBT Essentials course, please visit https://register.fit.edu/jsp/index.jsp and click on Applied Behavior Analysis under HOME SUB-CATEGORIES; then select the date range under Registered Behavior Technician Training.\n"+ "\n"
message2 += "Please let us know if you have any questions or concerns. You can contact us by emailing abareg@fit.edu or calling 1-321-674-8382, option 2. We're available by phone from 9:00 AM to 5:00 PM Eastern time Monday through Friday, excluding university holidays.\n" + "\n"

# Get deactivation list
deactivation = Array.new
reminder = Array.new
reminderConfirm = ""
stuInfo.each do |st|
  if (Date.today == DateTime.parse(st[:deadline].to_s).to_date)
    deactivation.push(:enroll => st[:enrollID], :id => st[:id], :name => st[:name], :course => st[:course], :sbmtime => st[:sbmtime].to_s, :deadlineDay => st[:deadline].to_s)
  end

  if (Date.today == DateTime.parse(st[:reminder].to_s).to_date)
    reminder.push(:enroll => st[:enrollID], :id => st[:id], :name => st[:name], :course => st[:course], :sbmtime => st[:sbmtime].to_s, :reminderDay => st[:reminder].to_s)

    #send reminder to student
    canvas.post("/api/v1/conversations", {'recipients[]' => st[:id].to_s, 'subject' =>'Reminder: The Deadline for Your RBT Course Is Approaching', 'body' => message, "group_conversation" => true, "bulk_message" => true})

    reminderConfirm = reminderConfirm + st[:name].to_s + "\n"
  end
  # end stuInfo
end

puts "------------------------------------------------------------------------------------------------------"
#command line print statements
header = "#{reminder.length} students were reminded of the 180-day deadline today."
puts header
puts reminder
puts "------------------------------------------------------------------------------------------------------"
header2 = "There are #{deactivation.length} students to deactivate today."
puts header2
puts deactivation
puts "------------------------------------------------------------------------------------------------------"

# send email to staff (reminders)
canvas.post("/api/v1/conversations", {'recipients[]' => '1842270', 'subject' =>'RBT reminders for '+Date.today.to_s, 'body' => header+"\n\n"+reminderConfirm, "group_conversation" => true, "bulk_message" => true}) #Stephanie
canvas.post("/api/v1/conversations", {'recipients[]' => '1874990', 'subject' =>'RBT reminders for '+Date.today.to_s, 'body' => header+"\n\n"+reminderConfirm, "group_conversation" => true, "bulk_message" => true}) #Jenn
canvas.post("/api/v1/conversations", {'recipients[]' => '777482', 'subject' =>'RBT reminders for '+Date.today.to_s, 'body' => header+"\n\n"+reminderConfirm, "group_conversation" => true, "bulk_message" => true}) #Theresa
canvas.post("/api/v1/conversations", {'recipients[]' => '1873108', 'subject' =>'RBT reminders for '+Date.today.to_s, 'body' => header+"\n\n"+reminderConfirm, "group_conversation" => true, "bulk_message" => true}) #Marisell

if reminder.length == 0
  canvas.post("/api/v1/conversations", {'recipients[]' => '777482', 'subject' =>'RBT reminders for ' + Date.today.to_s, 'body' => "No reminders for RBT today!", "group_conversation" => true, "bulk_message" => true}) #Theresa
  canvas.post("/api/v1/conversations", {'recipients[]' => '1842270', 'subject' =>'RBT reminders for ' + Date.today.to_s, 'body' => "No reminders for RBT today!", "group_conversation" => true, "bulk_message" => true}) #Stephanie
  canvas.post("/api/v1/conversations", {'recipients[]' => '1874990', 'subject' =>'RBT reminders for ' + Date.today.to_s, 'body' => "No reminders for RBT today!", "group_conversation" => true, "bulk_message" => true}) #Jenn
  canvas.post("/api/v1/conversations", {'recipients[]' => '1873108', 'subject' =>'RBT reminders for ' + Date.today.to_s, 'body' => "No reminders for RBT today!", "group_conversation" => true, "bulk_message" => true}) #Marisell
  puts "No reminders for RBT today!"
end

# deactivate students
deactConfirm = ""
deactivation.each do |deact|
    #deactivate current student
    canvas.delete("/api/v1/courses/" + deact[:course].to_s + "/enrollments/" + deact[:enroll].to_s, {'task' =>'inactivate'})

    # send deactivation message to student
    canvas.post("/api/v1/conversations", {'recipients[]' => deact[:id].to_s, 'subject' =>'Important: Your Access to RBT Essentials Has Expired', 'body' => message2, "group_conversation" => true, "bulk_message" => true})
    deactConfirm = deactConfirm + deact[:name].to_s + " has been deactivated.\n"
    puts deact[:name].to_s + " has been deactivated and an email has been sent to them."
end

# send email to staff (deactivations)
canvas.post("/api/v1/conversations", {'recipients[]' => '777482', 'subject' =>'RBT Deactivations for ' + Date.today.to_s, 'body' => header2+"\n\n"+deactConfirm, "group_conversation" => true, "bulk_message" => true}) #Theresa
canvas.post("/api/v1/conversations", {'recipients[]' => '1842270', 'subject' =>'RBT Deactivations for ' + Date.today.to_s, 'body' => header2+"\n\n"+deactConfirm, "group_conversation" => true, "bulk_message" => true}) #Stephanie
canvas.post("/api/v1/conversations", {'recipients[]' => '1874990', 'subject' =>'RBT Deactivations for ' + Date.today.to_s, 'body' => header2+"\n\n"+deactConfirm, "group_conversation" => true, "bulk_message" => true}) #Jenn
canvas.post("/api/v1/conversations", {'recipients[]' => '1873108', 'subject' =>'RBT Deactivations for ' + Date.today.to_s, 'body' => header2+"\n\n"+deactConfirm, "group_conversation" => true, "bulk_message" => true}) #Marisell

if deactivation.length == 0
  canvas.post("/api/v1/conversations", {'recipients[]' => '777482', 'subject' =>'RBT Deactivations for ' + Date.today.to_s, 'body' => "No deactivations for RBT today!", "group_conversation" => true, "bulk_message" => true}) #Theresa
  canvas.post("/api/v1/conversations", {'recipients[]' => '1842270', 'subject' =>'RBT Deactivations for ' + Date.today.to_s, 'body' => "No deactivations for RBT today!", "group_conversation" => true, "bulk_message" => true}) #Stephanie
  canvas.post("/api/v1/conversations", {'recipients[]' => '1874990', 'subject' =>'RBT Deactivations for ' + Date.today.to_s, 'body' => "No deactivations for RBT today!", "group_conversation" => true, "bulk_message" => true}) #Jenn
  canvas.post("/api/v1/conversations", {'recipients[]' => '1873108', 'subject' =>'RBT Deactivations for ' + Date.today.to_s, 'body' => "No deactivations for RBT today!", "group_conversation" => true, "bulk_message" => true}) #Marisell
  puts "No deactivations for RBT today!"
end

puts "------------------------------------------------------------------------------------------------------"
puts "All done!"
