#######################################################################
#
# MON-DASH-US1099.rb
# US1097 - Test dashboard as a monitor
#
# Scott Wedel
# 31 October 2013
#
#######################################################################

require 'rubygems'
require 'watir-webdriver'
require 'headless'

# vars

login = 'mtest'
pw = '1qaz@WSX'
site = 'http://ec2-54-218-202-102.us-west-2.compute.amazonaws.com'
test_count = 0
fail_count = 0
loop = 0

menus = ['Monitored', 'Not Monitored', 'My Queries', 'Trial Intel']


# start up browser after starting headless

# uncomment the line corresponding to the browser against which you want to test (blank = firefox)

headless = Headless.new
headless.start

# b = Watir::Browser.new
b = Watir::Browser.new :chrome
# b = Watir::Browser.new :ie

b.goto site

b.text_field( :id, 'username' ).when_present.set login
b.text_field( :id, 'password' ).when_present.set pw
btn = b.button( :class, 'btn btn-default btn-block' ).click

# wait for dashboard to load
sleep 3

b.link( :title => 'Show/Hide Navigation Menu' ).when_present.click

# assert correct user logged in

utst = b.text.include? 'Hi, M FULL'

test_count +=1

if ( utst == true )
	puts "Correct user logged in: PASS"
else
	puts "Correct user logged in: FAIL"
	fail_count +=1
end

# assert that the proper menu items exist

b.link( :title => 'Show/Hide Navigation Menu' ).when_present.click


m_tst = b.link( :text => 'Monitored' ).exists?
nm_tst = b.link( :text => 'Not Monitored' ).exists?
myq_tst = b.link( :text => 'My Queries' ).exists?
ti_tst = b.link( :text => 'Trial Intel' ).exists?

test_count += 1
if (m_tst == true && nm_tst == true && myq_tst == true && ti_tst == true )
	puts "Correct Menu Items: PASS"
else
	puts "Correct Menu Items: FAIL"
	fail_count +=1
end


# assert that correct line items come up

while loop < menus.length

	
	in_test_perm = 'Permissions Correct'	
	in_test_links = 'PropLinksExist'
	in_test_acc = 'AccExpand'

	case loop
	when 0 #Monitored

		b.link( :text => menus[loop] ).click
		sleep 3

		b.link( :text => '101' ).click
		sleep 3

		exist = b.link( :text => 'View' ).exists?

		test_count +=1		
		if exist == true
			puts menus[loop].to_s + " - " + in_test_acc + ": PASS"
		else
			puts menus[loop].to_s + " - " + in_test_acc + ": FAIL"
			fail_count +=1
		end
		
	when 1 #Not Monitored

		b.link( :text => menus[loop] ).click
		sleep 3

		
		# for loop to test 101-103
		
		for pos in 1..3

			# puts pos.to_s			
			el = "#unmonitoredTitle" + pos.to_s + " > a"

			b.element(:css, el).click
			sleep 3
		
			exist = b.link( :text => 'View' ).exists?

				test_count +=1
		
				if exist == true
					puts menus[loop].to_s + " - " + in_test_acc + " 10" + pos.to_s + ": PASS"
				else
					puts menus[loop].to_s + " - " + in_test_acc + " 10" + pos.to_s + ": FAIL"
					fail_count +=1
				end
			end

	when 2 #My Queries

		b.link( :text => menus[loop] ).click
		sleep 3

		b.link( :text => 'Other Queries I did NOT create' ).click
		sleep 3

		exist = b.link( :text => 'View' ).exists?

		test_count +=1
		
		if exist == true
			puts menus[loop].to_s + " - " + in_test_acc + ": PASS"
		else
			puts menus[loop].to_s + " - " + in_test_acc + ": FAIL"
			fail_count +=1
		end		
		

	when 3 #Trial Intel

		b.link( :text => menus[loop] ).click
		sleep 3

		np_tst = b.text.include? 'Access Denied'
		
		test_count += 1
		if np_tst == true
			puts menus[loop].to_s + " - " + in_test_perm + ": PASS"
		else
			puts menus[loop].to_s + " - " + in_test_perm + ": FAIL"
			fail_count +=1
		end
	end		

loop +=1
end

# END: print final run/error counts and close browser

countstr = test_count.to_s + " tests run with " + fail_count.to_s + " failures"
puts countstr


b.close
headless.destroy




