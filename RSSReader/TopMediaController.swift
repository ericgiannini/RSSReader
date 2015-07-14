/*

This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike
4.0 International License, by Yong Bakos.

*/

import UIKit

class TopMediaController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBInspectable var feedURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSURLRequest(URL: NSURL(string: feedURL)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            if let feed = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as? NSDictionary,
                title = feed.valueForKeyPath("feed.entry.im:name.label") as? String,
                artist = feed.valueForKeyPath("feed.entry.im:artist.label") as? String,
                imageURLs = feed.valueForKeyPath("feed.entry.im:image") as? [NSDictionary] {
                    if let imageURL = imageURLs.last,
                        imageURLString = imageURL.valueForKeyPath("label") as? String {
                            self.loadImageFromURL(NSURL(string:imageURLString)!)
                    }
                self.titleLabel.text = title
                self.titleLabel.hidden = false
                self.artistLabel.text = artist
                self.artistLabel.hidden = false
                
            }
        }
    }
    
    func loadImageFromURL(URL: NSURL) {
        let request = NSURLRequest(URL: URL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            self.imageView.image = UIImage(data: data)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
}
