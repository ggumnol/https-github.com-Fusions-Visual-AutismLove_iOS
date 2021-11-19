//
//  Strings.swift
//  AutismLove
//
//  Created by Samuel Krisna on 24/04/21.
//

import Foundation

struct Strings {
    
    // General
    static let Authenticating = "Authenticating".localized()
    static let Confirm = "Confirm".localized()
    static let Finish = "Finish".localized()
    static let Cancel = "Cancel".localized()
    static let Submit = "Submit".localized()
    static let Resubmit = "Resubmit".localized()
    static let Message = "Message".localized()
    static let Call = "Call".localized()
    static let Won = "Won".localized()
    static let Accept = "Accept".localized()
    static let Reject = "Reject".localized()
    static let New = "New".localized()
    static let Signup_Completed = "Signup Completed".localized()
    
    // Tab bar
    static let Home = "Home".localized()
    static let Transaction = "Transaction".localized()
    static let Grant_Request = "Grant Request".localized()
    static let Messaging = "Messaging".localized()
    static let My_Page = "My Page".localized()
    
    static let My_User_Information = "My User Information".localized()
    
    static let My_Trust_Fund_Property = "My Trust Fund Property".localized()
    static let Money_I_Entrusted = "Money I entrusted to the Korea Autism Society".localized()
    static let Contract_Period_ = "Contract Period:".localized()
    
    // Request Form
    static let Grant_Request_Form_Title = "Grant Request Form".localized()
    static let Users_Grants_Request_List = "Users Grants Request List".localized()
    static let I_Need_More_Money = "I need more money than promised You can see the applications for the association.".localized()
    
    static let Grant_Request_List = "Grant Request List".localized()
    static let Edit_Grant_Request = "Edit Grant Request".localized()
    
    static let Request_Reason_Title = "Request reason :".localized()
    static let Usage_Title = "Usage :".localized()
    static let Amount_Title = "Amount :".localized()
    static let Grant_Date_Title = "Grant date :".localized()
    static let Requester_Title = "Requester :".localized()
    static let Status_Title = "Status :".localized()
    
    static let Add_New_Grant_Request = "+ Add New Grant Request".localized()
    static let Download_Request_Lists = "Download Request Lists".localized()
    
    static let View_Grants_Request_Document = "View Grants Request Document".localized()
    static let Delete_Request = "Delete Request".localized()
    
    static let Reason_For_Rejection = "Reason for Rejection".localized()
    static let Proof_Completed = "User proof attached".localized()
    static let Upload_Proof = "User proof none".localized()
    
    struct GrantRequestStatus {
        static let REJECT = "REJECT".localized()
        static let ACCEPT = "ACCEPT".localized()
        static let WAITING = "WAITING".localized()
        static let MONEY_TRANSFERED = "ACCEPT".localized()
    }
    
    struct GrantRequestFormStrings {
        static let Request_Reason_Title = "1. What is the reason for the request?".localized()
        static let Usage_Title = "2. Where are you using it?".localized()
        static let Date_Title = "3. Select grant date".localized()
        static let Upload_Proof_Title = "4. Upload proof image".localized()
        static let Requester_Title = "5. Requester".localized()
        
        static let Upload_Later = "Upload later".localized()
        
        static let resubmit = "Confirm Edit/Resubmit".localized()
    }
    
    struct AddEditUsageStrings {
        static let Add_Edit_Usage_Title = "Add/Edit Usage".localized()
        static let Recipient = "Recipient".localized()
        static let User_Input = "User Input".localized()
        static let Bank_Name = "Bank Name".localized()
        static let Account_Number = "Account Number".localized()
        static let Request_Amount = "Request Amount".localized()
        
        static let Send_To_Other = "Send to Other".localized()
        static let Send_To_Me = "Send to Me".localized()
        static let Send_To_User = "Send to User".localized()
    }
    
    static let Photo = "Photo.".localized()
    
    // MARK: PASSWORD CHECK
    static let Password_Check = "Password Check".localized()
    static let Input_Your_Password = "Input Your Password.".localized()
    
    // MARK: SIGNATURE STRINGS
    static let Signature = "Signature".localized()
    static let Signature_Description = "Formally request the payment of a grant from the trust funds for the following reasons".localized()
    static let Rewrite = "Rewrite".localized()
    
    // MARK: ERROR STRINGS
    static let Empty_Field = "Please fill all empty field".localized()
    static let Password_Is_Not_The_Same = "Password is not the same".localized()
    static let Must_be_equal_to_or_longer_than_6_letters = "Must be equal to or longer than 6 letters".localized()
    static let Email_Is_Not_Valid = "The email entered is not valid".localized()
    static let Phone_Must_Between_Characters = "Phone Number must between 10 - 13 digits".localized()
    static let Phone_Must_Begin_With_0 = "Must begin with 0".localized()
    
    static let No_Internet_Connection = "Not Internet Connection, please check your connectivity again.".localized()
    static let No_Message = "No message.".localized()
    
    // MARK: LOGIN STRINGS
    
    static let Remember_Id = "Remember ID".localized()
    static let Login = "Login".localized()
    static let Recover_Id = "Recover ID".localized()
    static let Replace_Password = "Replace Password".localized()
    static let Sign_Up = "Sign Up".localized()
    static let ID = "ID".localized()
    static let Password = "Password".localized()
    static let Logged_In = "Logged In".localized()
    
    // MARK: VERIFICATION
    
    static let Verification_Subtitle_1 = "Enter the mobile number you entered when signing up".localized()
    static let Mobile_Number_Placeholder = "Mobile Number".localized()
    static let Send_Verification_Number = "Send Verification Number".localized()
    static let Verification_Subtitle_2 = "Enter the verification code you received".localized()
    static let Enter_Verification_Number = "Enter Verification Code".localized()
    static let Enter_Your_Id = "Enter your ID".localized()
    
    
    // MARK: RECOVER ID
    static let Your_ID_Is = "Your ID is ".localized()
    static let Return_To_Login = "Return To Login".localized()
    
    
    // MARK: REPLACE PASSWORD
    
    // Replace Password
    static let New_Password = "New Password".localized()
    static let New_Password_Subtitle = "Enter New Password".localized()
    static let Confirm_Password = "Confirm Password".localized()
    static let Confirm_Return_To_Login = "Confirm & Return To Login".localized()
    static let Loading = "Loading".localized()
    
    // MARK: SIGN UP
    
    // Sign Up Strings
    static let Sign_Up_Subtitle = "Thank you for visiting our trust fund and decision making support center. Please click on the type of user you want to signup as".localized()
    static let User = "User".localized()
    static let Volunteer = "Volunteer".localized()
    static let Support_Agency = "Support Agency".localized()
    
    static let User_Sign_Up_Subtitle = "Please agree on the user agreements".localized()
    static let Sign_Up_Agreements_Alert = "Please agree to all required agreements".localized()
    static let Sign_Up_Agree_all = "Agree All".localized()
    static let Required_Agreement = "Required Agreement".localized()
    static let User_Sign_Up_Agreement = "User signup agreement".localized()
    static let Private_Data_Collection_Agreement = "Private data collection agreement".localized()
    static let Optional_Agreements = "Optional Agreements".localized()
    static let Notification_Push_Agreement = "Notification push agreement".localized()
    
    static let Next = "Next".localized()
    static let Verify = "Verify".localized()
    static let ID_Password_Input = "Input id and password".localized()
    static let Input_User_Information = "Input user information".localized()
    static let Input_Volunteer_Information = "Input volunteer information".localized()
    static let Input_Support_Agent_Information = "Input support agent information".localized()
    static let Verifiying = "Verifying".localized()
    static let You_Have_Been_LogOut = "You have been logged out".localized()
    
    static let Name = "Name".localized()
    static let Birthdate = "Birthdate".localized()
    static let Birthdate_Placeholder = "yyyy-mm-dd".localized()
    static let Contact_Number = "Contact Number".localized()
    static let Job_Title = "Job Title".localized()
    
    static let Phone_Placeholder = "Phone number begins with 0".localized()
    static let Please_Verify_Email_First = "Please try to verify your email first, then proceed".localized()
    static let Sending_OTP = "Sending OTP".localized()
    static let OTP_SENT = "OTP Sent".localized()
    static let Password_Has_Been_Reset = "Your Password Has Been Reset".localized()
    
    static let Registering = "Registering".localized()
    
    // MARK: MY PAGE
    static let My_Volunteer_Info = "My Volunteer Info.".localized()
    static let My_Manager_Info = "My Manager Info.".localized()
    
    static let Check_My_Documents = "Check My Documents".localized()
    static let User_Information = "User Information".localized()
    
    static let View_Contacts = "View Contacts".localized()
    static let View_Support_Plan = "View Support Plan".localized()
    static let View_User_Agreement = "View User Agreement".localized()
    static let View_Manager_Information = "View Manager Information".localized()
    static let View_Volunteer_Information = "View Volunteer Information".localized()
    
    static let Contact_Info = "Contact Info.".localized()
    static let Account_Info = "Account Info.".localized()
    static let Contract_Period_Start = "Contract Period Start".localized()
    static let Contract_Period = "Contract Period".localized()
    static let Notification_Setting = "Notification Setting".localized()
    static let Message_Alerts = "Message Alerts".localized()
    static let Request_Alerts = "Request Alerts".localized()
    static let Informative_Alerts = "Informative Alerts".localized()
    
    static let Will_You_Logout = "Will you log out?".localized()
    static let Edit = "Edit".localized()
    static let Logout = "Logout".localized()
    static let Change_Password = "Change Password".localized()
    static let Terminate_Account = "Terminate Account".localized()
    static let Your_Account_Has_Been_Terminated = "Your Account Has Been Terminated".localized()
    
    static let Save = "Save".localized()
    static let Terminate_The_Account = "Terminate the account?".localized()
    static let Terminate = "Terminate".localized()
    
    static let Enter_Your_Password = "Enter your password".localized()
    
    static let Download_PDF = "Download PDF".localized()
    
    
    // MARK: TRANSACTION
    static let Newest = "Newest".localized()
    static let Oldest = "Oldest".localized()
    static let Today = "Today".localized()
    static let One_Week = "1 Week".localized()
    static let One_Month = "1 Month".localized()
    static let Six_Months = "6 Months".localized()
    static let Search = "Search".localized()
    static let Download = "Download".localized()
    static let Grouping_OFF = "Grouping OFF".localized()
    static let Grouping_ON = "Grouping ON".localized()
    static let Newest_Contract = "Newest Contract".localized()
    static let Oldest_Contract = "Oldest Contract".localized()
    static let My_Users_Account_Info = "My Users Account Info".localized()
    static let Download_Has_Been_Completed = "Download Has Been Completed".localized()
    static let Pull_To_Refresh = "Pull to Refresh".localized()
    static let Order_Settings = "Order Settings".localized()
    static let Group_Users_By_Volunteers = "Group Users by Volunteers".localized()
    static let Orders = "Orders".localized()
    static let Oldest_Constract = "Oldest Contract".localized()
    static let ON = "ON".localized()
    static let OFF = "OFF".localized()
    static let Desired_Date = "Desired Date".localized()
}
