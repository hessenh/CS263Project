package plus;

import java.util.Collection;
import java.util.Map;

interface GP_PublicUser {  
    
    /** Identifies this resource as a person. Value: "plus#person". */  
    public String getKind();  
    /** The ID of this person. */  
    public String getId();  
    /** The name of this person, suitable for display. */  
    public String getDisplayName();  
    /** The brief description (tagline) of this person. */  
    public String getTagline();  
    /** The person's gender. Possible values are: {male|female|other}. */  
    public String getGender();  
    /** A short biography for this person. */  
    public String getAboutMe();  
    /** The URL of this person's profile. */  
    public String getURL();  
    /** The representation of the person's profile photo. */  
    public Map<String,String> getImage();  
    /** A list of URLs for this person. */  
    public Collection<Map<String,String>> getURLs();  
    /** A list of current or past organizations with which this person is associated. */  
    public Collection<Map<String,String>> getOrganizations();  
    /** A list of places where this person has lived. */  
    public Collection<Map<String,String>> getPlacesLived();  
}  