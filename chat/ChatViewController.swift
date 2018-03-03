//
//  ChatViewController.swift
//  chat
//
//  Created by Samba on 3/2/18.
//  Copyright © 2018 Samba. All rights reserved.
//

import UIKit
import Parse
class ChatViewController: UIViewController,UITableViewDataSource {
    
    @IBAction func logOut(_ sender: Any) {
        PFUser.logOutInBackground(block: { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Successful loggout")
                // Load and show the login view controller
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginViewController, animated: true, completion: nil)
            }
        })
    }
    
    var refreshControl: UIRefreshControl!

    
    var logs: [String] = []
    var users: [String] = []
    @IBOutlet weak var chatField: UITextField!
    @IBOutlet weak var table: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        cell.messageLabel.text = self.logs[indexPath.row]
        cell.userLabel.text = self.users[indexPath.row]
        
        return cell
    }
    @IBAction func sendMessage(_ sender: Any) {
        let user = PFUser.current()
        let chatMessage = PFObject(className: "Message")
        chatMessage["user"] = user
        chatMessage["text"] = chatField.text ?? ""
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.chatField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        table.dataSource = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(self.logOut(_:)))
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatViewController.didPullToRefresh(_:)), for: .valueChanged)
        table.insertSubview(refreshControl, at: 0)
        
        // Auto size row height based on cell autolayout constraints
        table.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        table.estimatedRowHeight = 50
        
        //chatField.addTarget(self, action: #selector(ChatViewController.textDidChange(_:)), for: .editingChanged)
        
        fetchMessages(nil)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fetchMessages(_:)), userInfo: nil, repeats: true)
        
        table.separatorStyle = .none

        // Do any additional setup after loading the view.
    }
    @objc func fetchMessages(_ sender:Any?){
        
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (messages, error) in
            if(messages != nil){
                self.logs = []
                self.users = []
                for message in messages!{
                    //self.logs.append(message["text"] as! String)
                    if(message["user"] != nil){
                        self.logs.append(message["text"] as! String)
                        self.users.append((message["user"] as! PFUser).username!)
                    }
                    else{
                        self.users.append("🤖")
                    }
                }
                self.table.reloadData()
            }
            else{
                print("Info:! \(String(describing: error?.localizedDescription))")
            }
        }
        self.refreshControl.endRefreshing()
    }
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        fetchMessages(nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
