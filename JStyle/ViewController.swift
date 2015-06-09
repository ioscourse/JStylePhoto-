//
//  ViewController.swift
//  JStyle
//
//  Created by Charles Konkol on 2015-06-03.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import UIKit
import MobileCoreServices
//0) Add import for CoreData
import CoreData
import Social


class ViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var imagescale:CGFloat!
    var savedimage:UIImage!
    var imgselected:Int = 0
    
    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var swipetext: UILabel!
    
    
    var showmessage:Bool=true
    
     var showmessage2:Bool=false
   
    var newImageData:NSData?
    var myImageFromData:NSData?
    //1) Add ManagedObject Data Context
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    //2) Add variable contactdb (used from UITableView
    var photodb:NSManagedObject!
    
 
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var cover: UIImageView!
    
    @IBOutlet weak var photos: UIImageView!
    
    @IBOutlet weak var camera: UIButton!
    
    @IBAction func scaleimage(sender: UIPinchGestureRecognizer) {
        
        self.photos.transform = CGAffineTransformScale(self.photos.transform, sender.scale, sender.scale)
        //println(sender.scale)
        
        sender.scale = 1
    }
    
    @IBOutlet weak var txtName: UITextField!
    
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
   
    
    @IBAction func btnSave(sender: AnyObject) {
        
        //4 Add Save Logic
        if (photodb != nil)
        {
            saveimage()
            
            photodb.setValue(txtName.text, forKey: "fullname")
            newImageData = UIImageJPEGRepresentation(savedimage, 1)
            photodb.setValue(newImageData, forKey: "photo")
           
        }
        else
        {
            saveimage()
            let entityDescription =
            NSEntityDescription.entityForName("HairStyles",
                inManagedObjectContext: managedObjectContext!)
            
            let photod = HairStyles(entity: entityDescription!,
                insertIntoManagedObjectContext: managedObjectContext)
            photod.fullname = txtName.text
            photod.photo = UIImageJPEGRepresentation(savedimage, 1)

        }
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            // status.text = err.localizedFailureReason
        } else {
            self.dismissViewControllerAnimated(false, completion: nil)
            
        }

        
    }
    
    
    @IBAction func btnBack(sender: AnyObject) {
        //3) Dismiss ViewController
        self.dismissViewControllerAnimated(false, completion: nil)

    }
    
  
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    @IBAction func camera(sender: AnyObject) {
    

        if txtName.text == ""
        {
            let alertController = UIAlertController(title: "Name Required", message:
                "Enter in Name before Taking Photo", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            showmessage = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            println("Take Photo of Animal")
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.Camera;
            imag.cameraDevice=UIImagePickerControllerCameraDevice.Front;
            //imag.mediaTypes = [kUTTypeImage];
            imag.allowsEditing = false
           
            self.presentViewController(imag, animated: true, completion: nil)
          
        }
        else
        {
            println("Take Photo of Animal")
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            //imag.mediaTypes = [kUTTypeImage];
            imag.allowsEditing = false
            
            self.presentViewController(imag, animated: true, completion: nil)
        }
              }

    }
    
    override func shouldAutorotate() -> Bool {
        
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //<#code#>
        if let touch = touches.first as? UITouch {
            DismissKeyboard()
        }
        super.touchesBegan(touches , withEvent:event)
     
       // draghair.center = touch.locationInView(self.view)
       

    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        let tapCount = touch.tapCount
        
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        let tapCount = touch.tapCount
        
        println(tapCount)
        // draghair.center = touch.locationInView(self.view)
    }
    
    
   
   
    //6 Add to hide keyboard
    func DismissKeyboard(){
        //forces resign first responder and hides keyboard
        txtName.endEditing(true)
      
        
    }
    //7 Add to hide keyboard
    func textFieldShouldReturn(textField: UITextField!) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }
    
  
  
    func loaddb()
    {
        //9 Add logic to load db. If contactdb has content that means a row was tapped on UiTableView
        if (photodb != nil)
        {
            //btnBack.enabled=true
            //cover.userInteractionEnabled = true
            //photos.userInteractionEnabled = true
            //topview.hidden = false
            //var loadSwitch:Bool
            txtName.text = photodb.valueForKey("fullname") as! String
            swipetext.hidden = false
            btnSave.title = ""
            txtName.hidden=true
            
            facebook.hidden = false
            twitter.hidden = false
           topview.hidden=false
            showmessage=false
            showmessage2=false
            swipetext.hidden=true
            camera.hidden=true
            navbar.hidden=false
            
            let myData: NSData? = photodb.valueForKey("photo") as? NSData
            cover.image = UIImage(data: myData!)
           //cover.bringSubviewToFront(view)
            photos.hidden = true
           topview.bounds.size.height = 75
        }
        else
        {
             bottombar.hidden = false
                 topview.hidden = false
            facebook.hidden = true
            twitter.hidden = true
             //swipe left & right
            swipetext.hidden=false
            camera.hidden=false
            camera.bringSubviewToFront(topview)
            swipetext.bringSubviewToFront(topview)
//             topview.bringSubviewToFront(topview)
//            bottombar.bringSubviewToFront(view)
           
            
        
       let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        }
        
       
        
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        //Adds tap gesture to view
        view.addGestureRecognizer(tap)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
        
      

    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
      
       
        if (sender.direction == .Left) {
            println("Swipe Left")
           imgselected += 1
      
        }
        
        if (sender.direction == .Right) {
            println("Swipe Right")
           
            imgselected -= 1
            if imgselected < 1
            {
                imgselected = 3
            }
        }
        
        
       
        println(imgselected)
        if imgselected == 4
        {
            imgselected = 1
        }
        
        switch imgselected
        {
        case 1:
            println("1")
            cover.image = UIImage(named:"jstyles2.png")!
           // swipetext.text = "Summer Style"
        case 2:
            println("2")
            cover.image = UIImage(named:"jstyles3.png")!
           //  swipetext.text = "Out On The Town Style"
        case 3:
            println("3")
            cover.image = UIImage(named:"jstyles.png")!
          //  swipetext.text = "Sunday Style"
        default:
            println("default")
            imgselected = 1
        }
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        loaddb()
        
        if showmessage == true{
            let alertController = UIAlertController(title: "Time to get J Styled!", message:
                "1) Enter FullName 2) Select J Style 3) Tap Camera", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            cover.userInteractionEnabled = false
            photos.userInteractionEnabled = false
            self.presentViewController(alertController, animated: true, completion: nil)
          
            //txtName.becomeFirstResponder()
        }
        
        if showmessage2 == true{
            let alertController = UIAlertController(title: "Move & Resize", message:
                "Move & Resize Image, Then Save", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            cover.userInteractionEnabled = false
            photos.userInteractionEnabled = true
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
       
        
    }
    
    @IBOutlet weak var facebook: UIButton!
    
    
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var myview: UIView!
    @IBOutlet weak var twitter: UIButton!
    
    
    @IBAction func twitterButtonPushed(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("I've been J Styled! with the JStyle App!")
            twitterSheet.addImage(cover.image)
           // twitterSheet.addURL(url)
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func facebookButtonPushed(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var fb = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            
            // add an image if needed.
            fb.addImage(cover.image)
            
            // Set the text for facebook share.
            fb.setInitialText("I've been J Styled! with the JStyle App!")

            
            // display composer view controller
            self.presentViewController(fb, animated: true, completion:nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tappedimage(sender:AnyObject)
    {
        println("imagetapped")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photos.contentMode = .ScaleAspectFit
            photos.image = pickedImage
            newImageData = UIImageJPEGRepresentation(pickedImage, 1)
            showmessage2=true
           
            photos.userInteractionEnabled = false
            cover.userInteractionEnabled = true
            btnSave.enabled=true
        }
        
       
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    @IBAction func btnHome(sender: UIBarButtonItem) {
        
    }
    
    func saveimage()
    {
        camera.hidden=true
        swipetext.hidden=true
        navbar.hidden=true
        bottombar.hidden = true
         savedimage = self.view?.pb_takeSnapshot()
      
        UIImageWriteToSavedPhotosAlbum(savedimage, nil, nil, nil)
        
    }
    
    @IBOutlet weak var bottombar: UIToolbar!
}


extension UIView {
    
    func pb_takeSnapshot() -> UIImage {
        var rect =  CGRectMake(0, 0,  UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(rect, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


