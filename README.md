Cherwell Monitoring in Production
=================================

I have been working on a couple of monitoring ideas for Cherwell. I didn't see anything with a quick online search, and I enjoy authoring MPs to monitor applications, it is the closest I'll get to 007.

I've hit a major hurdle and I need to ask for a hand from the community. We have a lab environment that's worked great while developing the Cherwell integration for Connection Center, however, it is not a good simulation for an actual deployment. While many of the components are in play, the usage patterns and requirements are far from a day-to-day used system.

Below are details on what has been drafted out so far, if you have any feedback or would like a copy of the MP please let me know at <nathan.foreman@cookdown.com>.

### Barebones MP

To get off the ground I've started with a DA that is largely centred around our single server instance, and should get a new top-level object. My first thoughts were to base a DA off the URL used to access the platform, however, this is one of many items I'd like to hear how the Cherwell community views things.

![The starting of a Distributed Application](https://images.squarespace-cdn.com/content/v1/5f35637fe609b4316220c424/1625587689154-IVC3S3IZBEJGTB8O5L82/Cherwell+Diagram.png?format=2500w)

The starting of a Distributed Application

In the skeleton today, properties are pulled of the Cherwell application server and a discovery fills in further information on connections defined for that server. For performance the initial discovery is registry based and targeted at the Windows OS, another item that I need help to confirm is applicable.

![InstallationDetails.png](https://images.squarespace-cdn.com/content/v1/5f35637fe609b4316220c424/1625588588859-YM3UNGTX214FOABJGD9V/InstallationDetails.png?format=1000w)

![ConnectionDefinition.png](https://images.squarespace-cdn.com/content/v1/5f35637fe609b4316220c424/1625588690285-A2B815BB2OI1240I20ZE/ConnectionDefinition.png?format=1000w)

### Growing further

IIS and SQL play a large role in the Cherwell ITSM platform, and both have Microsoft authored MPs that we can leverage. I have been drafting out models that use the base IIS and SQL classes to bring this data into the rudimentary DA above. Deployments that are in a server farm would benefit even more from bringing this all together.

![IIS Monitoring Relationships](https://images.squarespace-cdn.com/content/v1/5f35637fe609b4316220c424/1625588755047-XVK8LCTGJLETGLZOKX3Z/AppPools.png?format=1000w)

IIS Monitoring Relationships

![Possible relationship to the SQL DB](https://images.squarespace-cdn.com/content/v1/5f35637fe609b4316220c424/1625588443301-NKA5HJ377PQKDC54HI90/DatabaseCherwell.png?format=1000w)

Possible relationship to the SQL DB

If you have seen common pain points when using Cherwell that you think monitoring will help with, I would greatly appreciate your feedback and suggestions. Please send me an e-mail at <nathan.foreman@cookdown.com> or reach out on twitter @Nate_Foreman.
