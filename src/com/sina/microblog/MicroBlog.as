package com.sina.microblog
{
	import com.adobe.crypto.HMAC;
	import com.adobe.crypto.SHA1;
	import com.adobe.serialization.json.JSON;
	import com.dynamicflash.util.Base64;
	import com.sina.microblog.data.MicroBlogComment;
	import com.sina.microblog.data.MicroBlogCount;
	import com.sina.microblog.data.MicroBlogDirectMessage;
	import com.sina.microblog.data.MicroBlogProfileUpdateParams;
	import com.sina.microblog.data.MicroBlogRateLimit;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUnread;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.data.MicroBlogUsersRelationship;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.sina.microblog.utils.GUID;
	import com.sina.microblog.utils.StringEncoders;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.getClassByAlias;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.getDefinitionByName;
	
	/**
	 *  当OAuth过程发生错误时触发该事件.
	 *
	 *  <p>当consumerKey和consumerSecret不为空时，使用OAuth方式进行认证</p>
	 *
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="oauthCertifcateError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载公共微博消息成功时触发该事件.
	 *
	 *  <p>调用loadPublicTimeLine成功时，事件的<code>result</code>属性为一个<code>MicroBlogStatus</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadPublicTimeLineResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载公共微博消息失败时触发该事件.
	 *
	 *  <p>调用loadPublicTimeLine失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadPublicTimeLineError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载用户所有关注的用户最新的n条微博消息成功时触发该事件.
	 *
	 *  <p>调用loadFriendsTimeLine成功时，事件的<code>result</code>属性为一个<code>MicroBlogStatus</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFriendsTimeLineResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载用户所有关注的用户最新的n条微博消息失败时触发该事件.
	 *
	 *  <p>调用loadFriendsTimeLine失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFriendsTimeLineError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载指定用户的微博消息成功时触发该事件.
	 *
	 *  <p>调用loadUserTimeLine成功时，事件的<code>result</code>属性为一个<code>MicroBlogStatus</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadUserTimeLineResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载指定用户的微博消息失败时触发该事件.
	 *
	 *  <p>调用loadUserTimeLine失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadUserTimeLineError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载提及博主的微博消息成功时触发该事件.
	 *
	 *  <p>调用loadMensions成功时，事件的<code>result</code>属性为一个<code>MicroBlogStatus</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadMensionsResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载指定用户的微博消息失败时触发该事件.
	 *
	 *  <p>调用loadMensions失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadMensionsError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载对博主所发微博消息的评论成功时触发该事件.
	 *
	 *  <p>调用loadCommentsTimeline成功时，事件的<code>result</code>属性为一个<code>MicroBlogComment</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadCommentsTimelineResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载指定用户的微博消息失败时触发该事件.
	 *
	 *  <p>调用loadCommentsTimeline失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadCommentsTimelineError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载博主所发表评论成功时触发该事件.
	 *
	 *  <p>调用loadMyComments成功时，事件的<code>result</code>属性为一个<code>MicroBlogComment</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadMyCommentsResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载博主所发表评论失败时触发该事件.
	 *
	 *  <p>调用loadMyComments失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name = "loadMyCommentsError", type = "com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载博主所发表评论成功时触发该事件.
	 *
	 *  <p>调用loadCommentsToMe成功时，事件的<code>result</code>属性为一个<code>MicroBlogComment</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadCommentsToMeResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载博主所发表评论失败时触发该事件.
	 *
	 *  <p>调用loadCommentsToMe失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadCommentsToMeError", type="com.sina.microblog.events.MicroBlogErrorEvent")]	
	
	/**
	 *  当加载对微博消息的评论成功时触发该事件.
	 *
	 *  <p>调用loadCommentList成功时，事件的<code>result</code>属性为一个<code>MicroBlogComment</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadCommentsResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载对微博消息的评论失败时触发该事件.
	 *
	 *  <p>调用loadCommentList失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadCommentsError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载微博消息相关统计数据成功时触发该事件.
	 *
	 *  <p>调用loadStatusCounts成功时，事件的<code>result</code>属性为一个<code>MicroBlogCount</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadStatusCountsResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载微博消息相关统计数据失败时触发该事件.
	 *
	 *  <p>调用loadStatusCounts失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadStatusCountsError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  <p>调用loadStatusUnread成功时，事件的<code>result</code>属性为一个<code>MicroBlogUnread</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadStatusUnreadResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  <p>调用loadStatusUnread失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadStatusUnreadError", type="com.sina.microblog.events.MicroBlogErrorEvent")]	
	
	/**
	 *  当加载某个微博消息成功时触发该事件.
	 *
	 *  <p>调用loadStatusInfo成功时，事件的<code>result</code>属性为<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadStatusInfoResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载某个微博消息失败时触发该事件.
	 *
	 *  <p>调用loadStatusInfo失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadStatusInfoError", type="com.sina.microblog.events.MicroBlogErrorEvent")]	
	
	/**
	 *  当发布微博消息成功时触发该事件.
	 *
	 *  <p>调用updateStatus成功时，事件的<code>result</code>属性为刚发布的<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="updateStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当发布微博消息失败时触发该事件.
	 *
	 *  <p>调用updateStatus失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="updateStatusError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当删除微博消息成功时触发该事件.
	 *
	 *  <p>调用deleteStatus成功时，事件的<code>result</code>属性为被删除的<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API
	 */
	[Event(name="deleteStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当删除微博消息失败时触发该事件.
	 *
	 *  <p>调用deleteStatus失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="deleteStatusError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当转发某个微博消息成功时触发该事件.
	 *
	 *  <p>调用repostStatus成功时，事件的<code>result</code>属性为<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="repostStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当转发某个微博消息失败时触发该事件.
	 *
	 *  <p>调用repostStatus失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="repostStatusError", type="com.sina.microblog.events.MicroBlogErrorEvent")]	
	
	/**
	 *  当评论某个微博消息成功时触发该事件.
	 *
	 *  <p>调用commentStatus成功时，事件的<code>result</code>属性为<code>MicroBlogComment</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="commentStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当评论某个微博消息失败时触发该事件.
	 *
	 *  <p>调用commentStatus失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="commentStatusError", type="com.sina.microblog.events.MicroBlogErrorEvent")]	
	
	/**
	 *  当删除某个微博消息评论成功时触发该事件.
	 *
	 *  <p>调用deleteComment成功时，事件的<code>result</code>属性为<code>MicroBlogComment</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="deleteCommentResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当删除某个微博消息评论失败时触发该事件.
	 *
	 *  <p>调用deleteComment失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="deleteCommentError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当回复某个微博评论成功时触发该事件.
	 *
	 *  <p>调用replyStatus成功时，事件的<code>result</code>属性为<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="replyStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当回复某个微博评论失败时触发该事件.
	 *
	 *  <p>调用replyStatus失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name = "replyStatusError", type = "com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  <p>调用resetCount成功时，事件的<code>result</code>属性为<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="resetStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当回复某个微博评论失败时触发该事件.
	 *
	 *  <p>调用resetCount失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="resetStatusError", type="com.sina.microblog.events.MicroBlogErrorEvent")]	
	
	/**
	 *  当加载指定用户信息成功时触发该事件.
	 *
	 *  <p>调用loadUserInfo成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadUserInfoResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载指定用户信息失败时触发该事件.
	 *
	 *  <p>调用loadUserInfo失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadUserInfoError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载用户关注的博主列表成功时触发该事件.
	 *
	 *  <p>调用loadFriendsInfo成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFriendsInfoResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载用户关注的博主列表失败时触发该事件.
	 *
	 *  <p>调用loadFriendsInfo失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFriendsInfoError", type="com.sina.microblog.events.MicroBlogErrorEvent")]	
	
	/**
	 *  当加载关注用户的博主列表成功时触发该事件.
	 *
	 *  <p>调用loadFollowersInfo成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFollowersInfoResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载关注用户的博主列表失败时触发该事件.
	 *
	 *  <p>调用loadFollowersInfo失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFollowersInfoError", type="com.sina.microblog.events.MicroBlogErrorEvent")]	
	
	/**
	 *  <p>调用loadDirectMessagesReceived成功时，事件的<code>result</code>属性为<code>MicroBlogDirectMessage</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadDirectMessagesReceivedResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载接收到的私信列表失败时触发该事件.
	 *
	 *  <p>调用loadDirectMessagesReceived失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadDirectMessagesReceivedError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载发出的私信列表成功时触发该事件.
	 *
	 *  <p>调用loadDirectMessagesSent成功时，事件的<code>result</code>属性为<code>MicroBlogDirectMessage</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadDicrectMessagesSentResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载发出的私信列表失败时触发该事件.
	 *
	 *  <p>调用loadDirectMessagesSent失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadDicrectMessagesSentError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当发送私信成功时触发该事件.
	 *
	 *  <p>调用sendDirectMessage成功时，事件的<code>result</code>属性<code>MicroBlogDirectMessage</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="sendDirectMessageResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当发送私信失败时触发该事件.
	 *
	 *  <p>调用deleteDirectMessage失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="sendDirectMessageSentError", type="com.sina.microblog.events.MicroBlogErrorEvent")]	
	
	/**
	 *  当删除私信成功时触发该事件.
	 *
	 *  <p>调用deleteDirectMessage成功时，事件的<code>result</code>属性为被删除的<code>MicroBlogDirectMessage</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="deleteDirectMessageResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当删除私信失败时触发该事件.
	 *
	 *  <p>调用deleteDirectMessage失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="deleteDirectMessageError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当关注某博主成功时触发该事件.
	 *
	 *  <p>调用follow成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="followResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当关注某博主失败时触发该事件.
	 *
	 *  <p>调用follow失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="followError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当取消关注某博主成功时触发该事件.
	 *
	 *  <p>调用cancelFollowing成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="cancelFollowingResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当取消关注某博主失败时触发该事件.
	 *
	 *  <p>调用cancelFollowing失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="cancelFollowingError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当查询两个微博用户关系成功返回时触发该事件.
	 *
	 *  <p>调用checkIsFollowing成功时，事件的<code>result</code>属性<code>MicroBlogRelationship</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="checkIsFollowingResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当查询两个微博用户关系失败时触发该事件.
	 *
	 *  <p>调用checkIsFollowing失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="checkIsFollowingError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载博主关注的用户id列表成功时触发该事件.
	 *
	 *  <p>调用loadFriendsIDList成功时，事件的<code>result</code>属性<code>uint</code>
	 *  数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFriendsIDListResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载博主关注的用户id列表失败时触发该事件.
	 *
	 *  <p>调用loadFriendsIDList失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFriendsIDListError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加关注载博主的用户id列表成功时触发该事件.
	 *
	 *  <p>调用loadFollowersIDList成功时，事件的<code>result</code>属性<code>uint</code>
	 *  数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFollowersIDListResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载关注博主的用户id列表失败时触发该事件.
	 *
	 *  <p>调用loadFollowersIDList失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFollowersIDListError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当验证用户信息成功和登陆成功时触发该事件.
	 *
	 *  <p>调用verifyCrendentials成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  <p>注意：当使用Basic方式验证的时候调用login成功时也会触发该事件</p>
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="verifyCredentialsResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当验证用户信息失败时触发该事件.
	 *
	 *  <p>调用verifyCrendentials失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="verifyCredentialsError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当获取调用速率限制信息成功时触发该事件.
	 *
	 *  <p>调用getRateLimitStatus成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="getRateLimitStatusResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当获取调用速率限制信息失败时触发该事件.
	 *
	 *  <p>调用getRateLimitStatus失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="getRateLimitStatusError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当用户成功注销时触发该事件.
	 *
	 *  <p>调用logout成功时，事件的<code>result</code>属性<code>MicroBlogRateLimit</code>
	 *  数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="logoutResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当用户注销失败时触发该事件.
	 *
	 *  <p>调用logout失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="logoutError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当更新用户头像成功时触发该事件.
	 *
	 *  <p>调用updateProfileImage成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="updateProfileImageResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当更新用户头像失败时触发该事件.
	 *
	 *  <p>调用updateProfileImage失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="updateProfileImageError", type="com.sina.microblog.events.MicroBlogErrorEvent")]		
	
	/**
	 *  当更新用户信息成功时触发该事件.
	 *
	 *  <p>调用updateProfile成功时，事件的<code>result</code>属性<code>MicroBlogUser</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="updateProfileResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当更新用户信息失败时触发该事件.
	 *
	 *  <p>调用updateProfile失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="updateProfileError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当加载用户收藏列表成功时触发该事件.
	 *
	 *  <p>调用loadFavoriteList成功时，事件的<code>result</code>属性<code>MicroBlogStatus</code>
	 *  对象数组.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFavoriteListResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当加载用户收藏列表失败时触发该事件.
	 *
	 *  <p>调用loadFavoriteList失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="loadFavoriteListError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当收藏微博消息成功时触发该事件.
	 *
	 *  <p>调用addToFavorites成功时，事件的<code>result</code>属性<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="addToFavoritesResult", type="com.sina.microblog.events.MicroBlogEvent")]
	/**
	 *  当收藏微博消息失败时触发该事件.
	 *
	 *  <p>调用addToFavorites失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="addToFavoritesError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当将微博消息移出收藏列表成功时触发该事件.
	 *
	 *  <p>调用removeFromFavorites成功时，事件的<code>result</code>属性<code>MicroBlogStatus</code>
	 *  对象.</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="removeFromFavoritesResult", type="com.sina.microblog.events.MicroBlogEvent")]	
	/**
	 *  当将微博消息移出收藏列表失败时触发该事件.
	 *
	 *  <p>调用addToFavorites失败时，事件的<code>message</code>为失败原因描述</p>
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="removeFromFavoritesError", type="com.sina.microblog.events.MicroBlogErrorEvent")]
	
	/**
	 *  当请求未被验证，服务器调用产生安全错误时触发该事件.
	 *
	 *  @see flash.events.SecurityErrorEvent
	 *  
	 *  @langversion 3.0
	 *  @productversion MicroBlog-API 
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * MicroBlog是新浪微博AS3 API的核心类.
	 *
	 * <p>其主要功能包括：<br/>
	 * <ul>
	 * <li>封装核心的平台API</li>
	 * <li>封装了三种用户认证方式：OAuth授权和用户名/密码和PIN方式</li>
	 * <li>使用事件来返回API调用结果</li>
	 * <li>对API调用的结果(XML)进行强类型的封装</li>
	 * <li>提供通用接口以满足线上接口更新后sdk未封装的情况</li>
	 * </ul>
	 * 一般情况下，当一个API调用成功时，将会抛出一个<b>MicroBlogEvent</b>事件，而调用失败将会抛出<b>MicroBlogErrorEvent</b>事件。</br>
	 * 具体事件类型请参照函数说明文档。
	 * </p>
	 * <p>
	 * <b>例1 使用OAuth授权认证（推荐使用）</b>
	 * <pre><br/>
	 * public function init():void
	 * {
	 * 		_mb.source = xxxxxx; ///source是你申请的app key
	 * 		_mb.addEventListener(MicroBlogEvent.ANYWHERE_TOKEN_RESULT, onLoginResult); ///如果在别处已经登录，此时不用调用login()
	 * 		btnLogin.addEventListener(MouseEvent.CLICK, onLoginClick); 
	 * 		//_mb.login();也可以不侦听MicroBlogEvent.ANYWHERE_TOKEN_RESULT，直接调用login()去登录，为了浏览器不拦截授权弹出页，建议使用用户点击鼠标触发
	 * }
	 * private function onLoginClick(e:MouseEvent):void
	 * {
	 * 		_mb.addEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginResult);
	 *  	_mb.login();
	 * }
	 * private function onLoginResult(evt:MicroBlogEvent):void
	 * {
	 * 		//登录成功，可以访问微博数据了
	 * }
	 * </pre>
	 * </p>
	 * <p>
	 * <b>例2 使用用户名密码进行用户认证（只有在信任域或者AIR应用中使用。非信任域的网络应用无法使用）</b>
	 * <pre><br/>
	 * private var _mb:MicroBlog = new MicroBlog();
	 * public function init():void 
	 * {
	 * 		_mb.isTrustDomain = true;///设置为信任域
	 * 		_mb.source = xxxxxx; ///source是你申请的app key
	 * 		_mb.addEventListener(MicroBlogEvent.VERIFY_CREDENTIALS_RESULT, onVerifyResult);
	 * 		_mb.addEventListener(MicroBlogErrorEvent.VERIFY_CREDENTIALS_ERROR, onVerifyError);
	 * 		_mb.login(username, password); ///用户名密码登录后会请求用户数据，以确认是否输入有效
	 * }
	 * private function onVerifyResult(e:MicroBlogEvent):void
	 * {
	 * 		_mb.removeEventListener(MicroBlogEvent.VERIFY_CREDENTIALS_RESULT, onVerifyResult);
	 * 		_mb.removeEventListener(MicroBlogErrorEvent.VERIFY_CREDENTIALS_ERROR, onVerifyError);
	 * 		//登录成功，可以访问微博数据了
	 * }
	 * private function onVerifyError(e:MicroBlogEvent):void
	 * {
	 * 		//输入的用户名或者密码错误
	 * }
	 * </pre>
	 * </p>
	 * <p>
	 * <b>例3 使用PIN码认证（只有在信任域或者AIR应用中使用。非信任域的网络应用无法使用）</b>
	 * <pre><br/>
	 * private var _mb:MicroBlog = new MicroBlog();
	 * public function init():void
	 * {
	 * 		_mb.isTrustDomain = true;
	 * 		_mb.source = xxxxxx; ///source是你申请的app key
	 * 		_mb.consumerKey = xxxxxx; ///app key
	 * 		_mb.consumerSecret = xxxxxx; ///app secret
	 * 		if ( accessTokenKey &#38;&#38; accessTokenSecret )
	 * 		//如果保存了用户认证过的Token，则不需要登陆，也不需要pin_onClick的调用过程
	 * 		{
	 * 			_mb.accessTokenKey = accessTokenKey;
	 * 			_mb.accessTokenSecret = accessTokenSecret;
	 * 		} else{
	 * 			_mb.login(null, null, true); ///用户名密码登录后会请求用户数据，以确认是否输入有效
	 * 		}
	 * }
	 * //当用户在网页上认证了该请求以后
	 * private function pin_onClick():void
	 * {
	 * 		_mb.addEventListener(MicroBlogEvent.VERIFY_CREDENTIALS_RESULT, onVerifyResult);
	 * 		_mb.addEventListener(MicroBlogErrorEvent.VERIFY_CREDENTIALS_ERROR, onVerifyError);
	 * 		_mb.pin = xxxxx;//
	 * }
	 * private function onVerifyResult(e:MicroBlogEvent):void
	 * {
	 * 		_mb.removeEventListener(MicroBlogEvent.VERIFY_CREDENTIALS_RESULT, onVerifyResult);
	 * 		_mb.removeEventListener(MicroBlogErrorEvent.VERIFY_CREDENTIALS_ERROR, onVerifyError);
	 * 		//登录成功，可以访问微博数据了
	 * }
	 * private function onVerifyError(e:MicroBlogEvent):void
	 * {
	 * 		//拷贝回来的PIN值无效
	 * }
	 * </pre>
	 * </p>
	 * <p>
	 * <b>例4 一个典型的服务器调用过程，包括调用api，监听事件</b>
	 * <pre><br/>
	 * private var _mb:MicroBlog = new MicroBlog();
	 * private function initListeners():void
	 * {
	 * 		_mb.addEventListener(MicroBlogEvent.LOAD_PUBLIC_TIMELINE_RESULT, mb_onPublicTimeline, false, 0, true);
	 * 		_mb.addEventListener(MicroBlogErrorEvent.LOAD_PUBLIC_TIMELINE_ERROR, mb_onError, false, 0, true);
	 * }
	 * public function loadPublicTimeline():void
	 * {
	 * 		_mb.loadPublicTimeline();
	 * }
	 * private function mb_onPublicTimeline(event:MicroBlogEvent):void
	 * {
	 * 		//处理成功返回的数据
	 * 		var data:Array = event.result;
	 * 		xxxxxx
	 * }
	 * private function mb_onError(event:MicroBlogErrorEvent):void
	 * {
	 * 		var msg:String = event.message;
	 * 		xxxxxxx
	 * }
	 * </pre>
	 * </p>
	 * <p>
	 * <b>例5 如何调用通用接口callGeneralApi</b>
	 * <pre><br/>
	 * private var _mb:MicroBlog = new MicroBlog();
	 * ///成功调用接口的事件类型
	 * public static const CUSTOM_RESULT_EVENT:String = "customResultEvent";
	 * ///失败的事件类型
	 * public static const CUSTOM_ERROR_EVENT:String = "customErrorEvent";
	 * ///调用此接口是在登录成功的情况下
	 * private function callGeneralApi():void
	 * {
	 * 		_mb.addEventListener(CUSTOM_RESULT_EVENT, onCustomResult, false, 0, true);
	 * 		_mb.addEventListener(CUSTOM_ERROR_EVENT, onCustomError, false, 0, true);
			var obj:Object = { };
			obj.count = 1;
			_mb.callGeneralApi("/statuses/mentions.xml", obj, CUSTOM_RESULT_EVENT, CUSTOM_ERROR_EVENT); ///分别传入线上的地址，参数对象，成功调取的事件类型以及失败后的事件类型
	 * }
	 * ///注意，此处的event类型需要写MicroBlogEvent,这样才能收到resut数据
	 * private function onCustomResult(event:MicroBlogEvent):void
	 * {
	 * 		//处理成功返回的数据
	 * 		var data:XML = event.result as XML;
	 * 		xxxxxx
	 * }
	 * ///注意，此处的event类型需要写MicroBlogErrorEvent,这样才能收到message数据
	 * private function onCustomError(event:MicroBlogErrorEvent):void
	 * {
	 * 		var msg:String = event.message;
	 * 		xxxxxxx
	 * }
	 * </pre>
	 * </p>
	 */
	public class MicroBlog extends EventDispatcher
	{
		private static const API_BASE_URL:String="http://api.t.sina.com.cn";		
		private static const PROXY_URL:String = "http://api.t.sina.com.cn/flash/proxy.jsp";

		private static const OAUTH_REQUEST_TOKEN_REQUEST_URL:String=API_BASE_URL + "/oauth/request_token";
		private static const OAUTH_AUTHORIZE_REQUEST_URL:String=API_BASE_URL + "/oauth/authorize";
		private static const OAUTH_ACCESS_TOKEN_REQUEST_URL:String=API_BASE_URL + "/oauth/access_token";

		private static const PUBLIC_TIMELINE_REQUEST_URL:String="/statuses/public_timeline.xml";
		private static const FRIENDS_TIMELINE_REQUEST_URL:String="/statuses/friends_timeline.xml";
		private static const USER_TIMELINE_REQUEST_URL:String="/statuses/user_timeline$user.xml";
		private static const MENTIONS_REQUEST_URL:String="/statuses/mentions.xml";
		private static const COMMENTS_TIMELINE_REQUEST_URL:String="/statuses/comments_timeline.xml";
		private static const COMMENTS_BY_ME_REQUEST_URL:String = "/statuses/comments_by_me.xml";
		private static const COMMENTS_TO_ME_REQUEST_URL:String = "/statuses/comments_to_me.xml"		
		private static const COMMENTS_REQUEST_URL:String="/statuses/comments.xml";
		private static const STATUS_COUNTS_REQUEST_URL:String = "/statuses/counts.xml";
		private static const STATUS_UNREAD_REQUEST_URL:String = "/statuses/unread.xml";

		private static const SHOW_STATUS_REQUEST_URL:String = "/statuses/show/$id.xml";
		////
		private static const UPDATE_STATUS_REQUEST_URL:String="/statuses/update.xml";
		private static const UPDATE_STATUS_WITH_IMAGE_REQUEST_URL:String="/statuses/upload.xml";
		private static const DELETE_STATUS_REQUEST_URL:String="/statuses/destroy/$id.xml";
		private static const REPOST_STATUS_REQUEST_URL:String="/statuses/repost.xml";
		private static const COMMENT_STATUS_REQUEST_URL:String="/statuses/comment.xml";
		private static const DELETE_COMMENT_REQUEST_URL:String="/statuses/comment_destroy/$id.xml";
		private static const REPLY_STATUS_REQUEST_URL:String = "/statuses/reply.xml";
		private static const RESET_STATUS_COUNT_REQUEST_URL:String = "/statuses/reset_count.xml";

		private static const LOAD_USER_INFO_REQUEST_URL:String="/users/show$user.xml";
		private static const LOAD_FRIENDS_INFO_REQUEST_URL:String="/statuses/friends$user.xml";
		private static const LOAD_FOLLOWERS_INFO_REQUEST_URL:String = "/statuses/followers$user.xml";
		
		private static const LOAD_DIRECT_MESSAGES_RECEIVED_REQUEST_URL:String="/direct_messages.xml";
		private static const LOAD_DIRECT_MESSAGES_SENT_REQUEST_URL:String="/direct_messages/sent.xml";
		private static const SEND_DIRECT_MESSAGE_REQUEST_URL:String="/direct_messages/new.xml";
		private static const DELETE_DIRECT_MESSAGE_REQUEST_URL:String="/direct_messages/destroy/$id.xml";		

		private static const FOLLOW_REQUEST_URL:String="/friendships/create$user.xml";
		private static const CANCEL_FOLLOWING_REQUEST_URL:String="/friendships/destroy$user.xml";
		private static const CHECK_IS_FOLLOWING_REQUEST_URL:String="/friendships/show.xml";

		private static const LOAD_FRIENDS_ID_LIST_REQUEST_URL:String="/friends/ids$user.xml";
		private static const LOAD_FOLLOWERS_ID_LIST_REQUEST_URL:String="/followers/ids$user.xml";
		
		private static const VERIFY_CREDENTIALS_REQUEST_URL:String="/account/verify_credentials.xml";
		private static const GET_RATE_LIMIT_STATUS_REQUEST_URL:String="/account/rate_limit_status.xml";
		private static const LOGOUT_REQUEST_URL:String="/account/end_session.xml";
		private static const UPDATE_PROFILE_IMAGE_REQUEST_URL:String="/account/update_profile_image.xml";
		private static const UPDATE_PROFILE_REQUEST_URL:String = "/account/update_profile.xml";
		//account/register 注册新浪微博帐号 
		//Account/activate 二次注册微博的接口 

		private static const LOAD_FAVORITE_LIST_REQUEST_URL:String="/favorites.xml";
		private static const ADD_TO_FAVORITES_REQUEST_URL:String="/favorites/create.xml";
		private static const REMOVE_FROM_FAVORITES_REQUEST_URL:String = "/favorites/destroy/$id.xml";
		
		private static const USER_ID:String="user_id";
		private static const SCREEN_NAME:String="screen_name";
		private static const SINCE_ID:String="since_id";
		private static const MAX_ID:String="max_id";
		private static const COUNT:String="count";
		private static const PAGE:String="page";
		private static const ROLE:String="role";
		private static const ID:String="id";
		private static const CURSOR:String="cursor";
		private static const FOLLOW:String="follow";
		private static const SOURCE_ID:String="source_id";
		private static const SOURCE_SCREEN_NAME:String="source_screen_name";
		private static const TARGET_ID:String="target_id";
		private static const TARGET_SCREEN_NAME:String = "target_screen_name";	
		private static const VERIFIER:String = "verifier";
		private static const MULTIPART_FORMDATA:String="multipart/form-data; boundary=";
		private static const CONTENT_DISPOSITION_BASIC:String='Content-Disposition: form-data; name="$name"';
		private static const CONTENT_TYPE_JPEG:String="Content-Type: image/pjpeg";
		private static const CONTENT_TRANSFER_ENCODING:String="Content-Transfer-Encoding: binary";	
		
		private var _consumerKey:String="";
		private var _consumerSecret:String="";
		private var _accessTokenKey:String="";
		private var _accessTokenSecret:String="";
		private var _pin:String="";
		private var _source:String = "";
		private var _verifier:String = "";
		private var authHeader:URLRequestHeader;
		
		///登录的时候临时建立的频道
		private var _localConnectionChanel:String;
		///获取anywheretoken值的连接
		private var _conn:LocalConnection;
		///通过此值获取用户当前状态，使用proxy接口时需要带上此值
		private var _anywhereToken:String = "";
		
		private var serviceLoader:Dictionary=new Dictionary();
		private var loaderMap:Dictionary = new Dictionary();
		private var oauthLoader:URLLoader;	
		
		///设置当前应用是否所在新浪open api的白名单域，如果为true则接口会尝试直接访问api.t下的接口而不使用代理
		private var _isTrustDomain:Boolean = false;
		 
		/**
		 * 默认使用代理，即请求"http://api.t.sina.com.cn/flash/proxy.jsp"，以便跨域请求api.t的接口
		 * 在air运行环境下，或者useProxy = true的情况下，直接去访问api.t目录。
		 */
		private var _useProxy:Boolean = true;
		
		/**
		 * 构造函数
		 */
		public function MicroBlog()
		{
			Security.loadPolicyFile("http://api.t.sina.com.cn/flash/crossdomain.xml");
			if (Capabilities.playerType == "Desktop") _useProxy = false;
		}

		/**
		 * consumerKey是一个只写属性，用于验证客户端的合法性，
		 * 必须在调用login之前将其设置为合适值.
		 */
		public function set consumerKey(value:String):void
		{
			if ( value )_consumerKey = value;
			else _consumerKey = "";
		}

		/**
		 * consumerSecret是一个只写属性，用于和consumerKey一起验证客户端的合法性，
		 * 必须在调用login之前将其设置为合适值.
		 */
		public function set consumerSecret(value:String):void
		{
			if ( value )_consumerSecret = value;
			else _consumerSecret = "";
		}
		
		/**
		 * pin是用于OAuth认证用的属性，由登陆页面生成.仅在登陆时使用.
		 */
		public function set pin(value:String):void
		{
			_pin=value;
			if ( oauthLoader )
			{
				var url:String=OAUTH_ACCESS_TOKEN_REQUEST_URL;
				var req:URLRequest=signRequest(URLRequestMethod.GET, url, null);
				oauthLoader.load(req);
				_pin = ""; // Just use once.
			}
		}
		
		/**
		 * accessTokenKey是用于OAuth认证的访问资源的token，由用户授权.
		 */
		public function get accessTokenKey():String { return _accessTokenKey; }
		public function set accessTokenKey(value:String):void
		{
			if (null != value) _accessTokenKey = value;
			else _accessTokenKey = "";
		}
				
		/**
		 * accessTokenSecret是用于OAuth认证的访问资源的token的密钥.
		 */
		public function get accessTokenSecrect():String { return _accessTokenSecret; }	
		public function set accessTokenSecrect(value:String):void
		{
			if (null != value) _accessTokenSecret = value;
			else _accessTokenSecret = "";
		}
		
		/**
		 * source是标识客户端来源.必须设置为新浪认证的应用程序id
		 */
		public function get source():String { return _source; }
		public function set source(value:String):void
		{
			_source = StringEncoders.urlEncodeUtf8String(value);		
			if (Capabilities.playerType != "Desktop") getAnywhereToken(); //如果走代理的接口说明是非信任域的app，需要获取anywhereToken值
		}		
		
		/**
		 * 微博秀的特殊需求创建，用于获取用户信息的标识，使用用户帐号的创建时间编码获得
		 */
		public function get verifier():String { return _verifier; }		
		public function set verifier(value:String):void 
		{
			_verifier = StringEncoders.urlEncodeUtf8String(value);
		}
		
		public function get anywhereToken():String { return _anywhereToken; }	
		public function set anywhereToken(value:String):void 
		{
			_anywhereToken = value;
		}
		
		/**
		 * 设置是否在信任域名单中，如果是true，此时请求数据可以不走代理接口而直接请求api
		 * 网络应用只有在信任域的情况下才能使用用户名密码登录或者pin登录（Air应用不受此限制）
		 */
		public function get isTrustDomain():Boolean { return _isTrustDomain; }		
		public function set isTrustDomain(value:Boolean):void 
		{
			_isTrustDomain = value;
			if (Capabilities.playerType != "Desktop") _useProxy = !_isTrustDomain;
		}
		
		private function getAnywhereToken():void
		{
			var ld:URLLoader = new URLLoader();
			ld.addEventListener(Event.COMPLETE, onTokenGot);
			ld.addEventListener(IOErrorEvent.IO_ERROR, onTokenError);
			var url:String = "http://api.t.sina.com.cn/flash/query.jsp?source=" + _source;
			ld.load(new URLRequest(url));
		}
		
		private function onTokenGot(evt:Event):void
		{
			var obj:Object = JSON.decode(evt.target.data);
			if (int(obj.status) == 1) {
				_anywhereToken = obj.anywhereToken;
				dispatchEvent(new MicroBlogEvent(MicroBlogEvent.LOGIN_RESULT));
				dispatchEvent(new MicroBlogEvent(MicroBlogEvent.ANYWHERE_TOKEN_RESULT));
			}else {
				dispatchEvent(new MicroBlogErrorEvent(MicroBlogErrorEvent.ANYWHERE_TOKEN_ERROR));
			}
		}
		
		private function onTokenError(evt:IOErrorEvent):void
		{
			var error:MicroBlogErrorEvent=new MicroBlogErrorEvent(MicroBlogErrorEvent.ANYWHERE_TOKEN_ERROR);
			error.message="获取anywhereToken值发生IOError";					
			dispatchEvent(error);
		}
		
		public function loginResult(anywhereToken:String):void
		{
			_anywhereToken = anywhereToken;
			dispatchEvent(new MicroBlogEvent(MicroBlogEvent.LOGIN_RESULT));
		}
		
		/**
		 * login封装了三种登录方式，anywhereToken的认证授权机制，OAuth的授权以及用户名密码的Base OAuth
		 * 用户民和密码的这种形式之能在Adobe AIR运行环境下才能使用，否则将会无效。
		 * login函数封装了OAuth所要求的验证的三个步骤，
		 * （之前输入的consumerKey和consumerSecret）
		 * 
		 * @param	userName			是合法的新浪微博用户名.
		 * @param	password			是与用户名对应的密码.
		 * @param	useStandardOAuth	使用标注OAuth登录，即PIN模式。这个模式必须在信任域的情况下才能使用。
		 * 
		 * login函数没有返回值，验证结果将采用消息的方式通知api调用者.
		 * @see com.sina.microblog.events.MicroBlogEvent#LOGIN_RESULT
		 */
		public function login(userName:String=null, password:String=null, useStandardOAuth:Boolean = false):void
		{
			if (userName != null && password != null) {
				var creds:String = userName + ":" + password;
				var encodedCredentials:String=Base64.encode(StringEncoders.utf8Encode(creds)).toString();
				authHeader=new URLRequestHeader("Authorization", "Basic " + encodedCredentials);
				verifyCredentials();
				return;
			}
			
			if (useStandardOAuth && !_useProxy)
			{				
				_accessTokenKey = "";
				_accessTokenSecret = "";
				if (_consumerKey.length > 0 && _consumerSecret.length > 0)
				{
					if (null == oauthLoader)
					{
						oauthLoader=new URLLoader();
						oauthLoader.addEventListener(Event.COMPLETE, oauthLoader_onComplete, false, 0, true);
						oauthLoader.addEventListener(IOErrorEvent.IO_ERROR, oauthLoader_onError, false, 0, true);
						oauthLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, oauthLoader_onSecurityError, false, 0, true);
					}
					var req:URLRequest=signRequest(URLRequestMethod.GET, OAUTH_REQUEST_TOKEN_REQUEST_URL, null);
					oauthLoader.load(req);
				}
				return;
			}
			
			_localConnectionChanel = _source + Math.round(Math.random() * 1000000);	
			_conn = new LocalConnection();
			_conn.client = this;
			_conn.connect("_" + String(_localConnectionChanel));
			_conn.allowDomain("*");
			var url:String = "http://api.t.sina.com.cn/oauth/login?source=" + _source;
			url += "&callback=http://api.t.sina.com.cn/flash/callback.htm";
			url += escape("?chanel=" + _localConnectionChanel);
			if (ExternalInterface.available) ExternalInterface.call("window.open", url,'newwindow','height=420,width=500,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no, z-look=yes, alwaysRaised=yes');
			else navigateToURL(new URLRequest(url), "_blank");
		}
		
		/**
		 * 调用未封装的接口，传入接口uri和所需参数对象即可
		 * <p>如果函数执行成功，会抛出传入的resultEventType类型</p>
		 * @param	uri				接口地址，例如：users/search
		 * @param	param			该接口所需要的参数对象
		 * @param	resultEventType	成功获取数据时的事件类型
		 * @param	errorEventType	发生错误时发出的事件类型
		 */
		public function callGeneralApi(uri:String, params:Object = null, resultEventType:String = "loadGeneralApiResult", errorEventType:String = "loadGeneralApiError"):void
		{
			if (uri.charAt(0) != "/") uri = "/" + uri;
			addProcessor(uri, processGeneralApi, resultEventType, errorEventType);
			if (params == null) var params:Object = { };
			params["_uri"] = uri;
			if(_useProxy) executeRequest(uri, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(uri, getMicroBlogRequest(API_BASE_URL + uri, params, URLRequestMethod.POST));
		}

		/**
		 * 返回最新更新的20条公共微博消息.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件<br/>
		 * type为<b>MicroBlogEvent.LOAD_PUBLIC_TIMELINE_ERROR</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了最新的20条微博消息.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.LOAD_PUBLIC_TIMELINE_ERROR</b></p>
		 */
		public function loadPublicTimeline():void
		{
			addProcessor(PUBLIC_TIMELINE_REQUEST_URL, processStatusArray, MicroBlogEvent.LOAD_PUBLIC_TIMELINE_RESULT, MicroBlogErrorEvent.LOAD_PUBLIC_TIMELINE_ERROR);
			var params:Object = new Object();
			params["_uri"] = PUBLIC_TIMELINE_REQUEST_URL;
			if(_useProxy) executeRequest(PUBLIC_TIMELINE_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(PUBLIC_TIMELINE_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + PUBLIC_TIMELINE_REQUEST_URL, params, URLRequestMethod.POST));
		}
		
		/**
		 * 返回用户所有关注的用户最新的n条微博消息.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_FRIENDS_TIMELINE_RESULT</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了所请求的微博消息.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.STATUS_FRIENDS_TIMELINE_ERROR</b><br/></p>
		 *
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 *
		 */
		public function loadFriendsTimeline(sinceID:String="0", maxID:String="0", count:uint=0, page:uint=0):void
		{
			addProcessor(FRIENDS_TIMELINE_REQUEST_URL, processStatusArray, MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, MicroBlogErrorEvent.LOAD_FRIENDS_TIMELINE_ERROR);
			var params:Object = new Object();		
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			params["_uri"] = FRIENDS_TIMELINE_REQUEST_URL;
			if (_useProxy) executeRequest(FRIENDS_TIMELINE_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(FRIENDS_TIMELINE_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + FRIENDS_TIMELINE_REQUEST_URL , params, URLRequestMethod.POST));
		}

		/**
		 * 返回用户发布的最新的n条微博消息.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_USER_TIMELINE_RESULT</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了所请求的微博消息.
		 * 由于分页限制，最多只能返回用户最新的300条微博信息</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.STATUS_USER_TIMELINE_ERROR</b></p>
		 *
		 * @param id 可选参数. 根据指定用户UID或用户帐号来返回微博信息.
		 * @param userID 可选参数. 指定用户UID来返回微博信息，主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 可选参数，指定用户的微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候。
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 */
		public function loadUserTimeline(id:*=null, userID:String="0", screenName:String=null, sinceID:String="0", maxID:String="0", count:uint=0, page:uint=0):void
		{
			addProcessor(USER_TIMELINE_REQUEST_URL, processStatusArray, MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, MicroBlogErrorEvent.LOAD_USER_TIMELINE_ERROR);
			var user:String;
			if (id) user="/" + String(id);
			else user="";
			var url:String=USER_TIMELINE_REQUEST_URL.replace("$user", user);
			var params:Object=new Object();
			makeUserParams(params, userID, screenName,  -1, verifier);
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			params["_uri"] = url;
			if(_useProxy) executeRequest(USER_TIMELINE_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(USER_TIMELINE_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}

		/**
		 * 返回最近n条提及我的微博消息.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_MENTIONS_RESULT</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了所请求的微博消息.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.STATUS_MENTIONS_ERROR</b></p>
		 *
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 *
		 */
		public function loadMentions(sinceID:String="0", maxID:String="0", count:uint=0, page:uint=0):void
		{
			addProcessor(MENTIONS_REQUEST_URL, processStatusArray, MicroBlogEvent.LOAD_MENSIONS_RESULT, MicroBlogErrorEvent.LOAD_MENSIONS_ERROR);
			var url:String=MENTIONS_REQUEST_URL;
			var params:Object=new Object();
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			params["_uri"] = url;
			if(_useProxy) executeRequest(MENTIONS_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(MENTIONS_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}

		/**
		 * 返回最近n条评论.
		 * 
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.LOAD_MENSIONS_RESUL</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了所请求的微博消息.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.LOAD_MENSIONS_ERROR</b></p>
		 *
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 *
		 */
		public function loadCommentsTimeline(sinceID:String="0", maxID:String="0", count:uint=0, page:uint=0):void
		{
			addProcessor(COMMENTS_TIMELINE_REQUEST_URL, processCommentArray, MicroBlogEvent.LOAD_COMMENTS_TIMELINE_RESULT, MicroBlogErrorEvent.LOAD_COMMENTS_TIMELINE_ERROR);
			var url:String=COMMENTS_TIMELINE_REQUEST_URL;
			var params:Object=new Object();
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			params["_uri"] = url;
			if(_useProxy) executeRequest(COMMENTS_TIMELINE_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(COMMENTS_TIMELINE_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}

		/**
		 * 返回我发表的评论.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_COMMENTS_BY_ME_RESULT</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了所请求的微博消息.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.STATUS_COMMENTS_TIMELINE_ERROR</b></p>
		 *
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 */
		public function loadMyComments(sinceID:String="0", maxID:String="0", count:uint=0, page:uint=0):void
		{
			addProcessor(COMMENTS_BY_ME_REQUEST_URL, processCommentArray, MicroBlogEvent.LOAD_MY_COMMENTS_RESULT, MicroBlogErrorEvent.LOAD_MY_COMMENTS_ERROR);
			var url:String=COMMENTS_BY_ME_REQUEST_URL;
			var params:Object=new Object();
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			params["_uri"] = url;
			if(_useProxy) executeRequest(COMMENTS_BY_ME_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(COMMENTS_BY_ME_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}	
		
		/**
		 * 返回当前用户收到的评论
		 * 
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 */
		public function loadCommentsToMe(sinceID:String="0", maxID:String="0", count:uint = 0, page:uint = 0):void
		{
			addProcessor(COMMENTS_TO_ME_REQUEST_URL, processCommentArray, MicroBlogEvent.LOAD_COMMENTS_TO_ME_RESULT, MicroBlogErrorEvent.LOAD_COMMENTS_TO_ME_ERROR);
			var url:String=COMMENTS_TO_ME_REQUEST_URL;
			var params:Object=new Object();
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			params["_uri"] = url;
			if(_useProxy) executeRequest(COMMENTS_TO_ME_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(COMMENTS_TO_ME_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}

		/**
		 * 返回指定微博的最新n条评论.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_COMMENTS_RESULT</b><br/>
		 * result为一个MicroBlogStatus数组，该数组包含了所请求的微博消息.</p>
		 *
		 * @param id 必选参数，指定微博ID.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 */
		public function loadCommentList(id:String, count:uint=0, page:uint=0):void
		{
			addProcessor(COMMENTS_REQUEST_URL, processCommentArray, MicroBlogEvent.LOAD_COMMENTS_RESULT, MicroBlogErrorEvent.LOAD_COMMENTS_ERROR);
			var url:String=COMMENTS_REQUEST_URL;
			var params:Object=new Object();
			params[ID]=id;
			makeQueryCombinatory(params, "0", "0", count, page);
			params["_uri"] = url;
			if(_useProxy) executeRequest(COMMENTS_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(COMMENTS_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url , params, URLRequestMethod.POST));
		}

		/**
		 * 批量统计微薄的评论数，转发数.单次最多获取100个.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.STATUS_COUNTS_RESULT</b><br/>
		 * result为一个MicroBlogCounts实例.</p>
		 *
		 * @param ids 必选参数，指定微博ID数组
		 */
		public function loadStatusCounts(ids:Array):void
		{
			addProcessor(STATUS_COUNTS_REQUEST_URL, processCounts, MicroBlogEvent.LOAD_STATUS_COUNTS_RESULT, MicroBlogErrorEvent.LOAD_STATUS_COUNTS_ERROR);
			var idsParam:String="";	
			if (null == ids || ids.length == 0) return;
			var len:int=ids.length - 1;
			for (var i:int=0; i < len; ++i)
			{
				idsParam+=ids[i].toString() + ",";
			}
			idsParam+=ids[len].toString();
			var params:Object=new Object();
			params["ids"]=idsParam;
			var url:String = STATUS_COUNTS_REQUEST_URL;
			params["_uri"] = url;
			if(_useProxy) executeRequest(STATUS_COUNTS_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(STATUS_COUNTS_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}
		
		/**
		 * 获取当前用户Web未读消息数，包括是否有新微博消息，&#64;我的, 新评论，新私信，新粉丝数。 
		 * <b>有请求数限制</b>
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.LOAD_STATUS_UNREAD_RESULT</b><br/>
		 * result为一个MicroBlogUnread实例.</p>
		 * 
		 * @param	withNewStatus	可选参数，默认为0。1表示结果包含是否有新微博，0表示结果不包含是否有新微博
		 * @param	sinceID			可选参数 参数值为微博id，返回此条id之后，是否有新微博产生，有返回1，没有返回0 
		 * 
		 * @see 	#resetCount()	对此接口清零接口
		 */
		public function loadStatusUnread(withNewStatus:uint = 0, sinceID:String = null):void
		{
			if (withNewStatus != 0 && withNewStatus != 1) return;			
			addProcessor(STATUS_UNREAD_REQUEST_URL, processUnread, MicroBlogEvent.LOAD_STATUS_UNREAD_RESULT, MicroBlogErrorEvent.LOAD_STATUS_UNREAD_ERROR);
			var params:Object = new Object();
			params["_uri"] = STATUS_UNREAD_REQUEST_URL;
			if (sinceID != null) 
			{
				if(sinceID.length > 0) params[SINCE_ID] = sinceID;
			}
			params["with_new_status"] = withNewStatus;
			if(_useProxy) executeRequest(STATUS_UNREAD_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(STATUS_UNREAD_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + STATUS_UNREAD_REQUEST_URL, params, URLRequestMethod.POST));
		}

		/**
		 * 获取单条ID的微博信息，作者信息将同时返回.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.SHOW_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogStatus实例.</p>
		 *
		 * @param id 必选参数，指定微博消息ID.
		 *
		 */
		public function loadStatusInfo(id:String):void
		{
			addProcessor(SHOW_STATUS_REQUEST_URL, processStatus, MicroBlogEvent.LOAD_STATUS_INFO_RESULT, MicroBlogErrorEvent.LOAD_STATUS_INFO_ERROR);
			var url:String = SHOW_STATUS_REQUEST_URL.replace("$id", id);
			var params:Object=new Object();
			params["_uri"] = url;
			if(_useProxy) executeRequest(SHOW_STATUS_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(SHOW_STATUS_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}
		
		/**
		 * 跳转到单条微博的Web地址。可以通过此url跳转到微博对应的Web网页。
		 * <p>如果允许当前flash访问js，会试图使用window.open的js方法打开，否则使用navigateToURL</p>
		 * 
		 * @param	uid			微博消息的发布者ID 
		 * @param	statusId	微博消息的ID 
		 */
		public function navigateToStatus(uid:String, statusId:String):void
		{
			var url:String = "http://api.t.sina.com.cn/" + uid + "/statuses/" + String(statusId);
			if (ExternalInterface.available) ExternalInterface.call("window.open", url, 'newwindow');
			else navigateToURL(new URLRequest(url), "_blank");
		}

		/**
		 * 发布一条微博信息.为防止重复，发布的信息与当前最新信息一样话，将会被忽略.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.UPDATE_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogStatus实例.</p>
		 *
		 * @param status 必选参数，要更新的微博信息,信息内容部超过140个汉字.
		 * @param filename 可选参数，上传的jpeg文件名.
		 * @param imgData 可选参数，为需要上传的jpeg文件数据，为空则不上传图片.
		 *
		 * 如果没有登录或超过发布上限，将返回错误
		 * 系统将忽略重复发布的信息.每次发布将比较最后一条发布消息，如果一样将被忽略.因此用户不能连续提交相同信息.
		 */
		public function updateStatus(status:String, filename:String=null, imgData:ByteArray=null):void
		{
			addProcessor(UPDATE_STATUS_REQUEST_URL, processStatus, MicroBlogEvent.UPDATE_STATUS_RESULT, MicroBlogErrorEvent.UPDATE_STATUS_ERROR);
			var req:URLRequest;
			var params:URLVariables=new URLVariables();
			
			if ( status ) params.status = encodeMsg(status);
			else if ( imgData == null ) return;		
			var url:String;
			if (imgData)
			{
				url = UPDATE_STATUS_WITH_IMAGE_REQUEST_URL;
				var tempParams:Object = { }; ///////////////////////////////////////////////////// PROXY_URL接口有个bug，后端开发朱磊（6587/zhulei@staff.sina.com.cn）要求此方法请求
				tempParams["_uri"] = url;
				tempParams["source"] = source;
				tempParams["_method"] = URLRequestMethod.POST;
				tempParams["_cache_time"] = "0";
				tempParams["_anywhereToken"] = _anywhereToken;
				
				if(_useProxy) req = new URLRequest(PROXY_URL + makeGETParamString(tempParams));
				else req = new URLRequest(API_BASE_URL + url + makeGETParamString(tempParams));
				
				if ( accessTokenKey.length > 0)
				{
					req=signRequest(URLRequestMethod.POST, url, params, false);
				}else{
					if ( authHeader ) req.requestHeaders.push(authHeader);
				}		
				req.method = URLRequestMethod.POST;			
				params.source = source;
				
				var boundary:String=makeBoundary();
				req.contentType = MULTIPART_FORMDATA + boundary;		
				req.data=makeMultipartPostData(boundary, "pic", filename, imgData, params);
			}
			else
			{
				url = UPDATE_STATUS_REQUEST_URL;
				params["_uri"] = url;
				if(_useProxy) req=getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST);
				else req=getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST);
			}		
			executeRequest(UPDATE_STATUS_REQUEST_URL, req);
		}

		/**
		 * 返回发布一条带图片的微博信息的<code>URLRequest对象</code>.
		 *
		 * <p>如果消息成功发送，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.UPDATE_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogStatus实例.</p>
		 *
		 * @return <code>URLRequest</code>对象，用于在flash中用File对象上传图片，在调用File对象的upload时uploadDataFieldName必须为pic。
		 *
		 * 如果没有登录或超过发布上限，将返回错误
		 * 系统将忽略重复发布的信息.每次发布将比较最后一条发布消息，如果一样将被忽略.因此用户不能连续提交相同信息.
		 *
		 * @see #updateStatus()
		 */
		public function getUploadImageRequest(status:String):URLRequest
		{
			var req:URLRequest;			
			var url:String=UPDATE_STATUS_WITH_IMAGE_REQUEST_URL;
			var params:URLVariables=new URLVariables();
			params.status = encodeMsg(status);
			params["_uri"] = url;
			if(_useProxy) req=getMicroBlogRequest(url, params, URLRequestMethod.POST);
			else req=getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST);
			return req;
		}

		/**
		 * 删除微博信息.注意：只能删除自己发布的信息.
		 * 
		 * <p> 如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.DELETE_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogStatus实例.</p>
		 *
		 * @param id 必填参数，要删除的微博信息ID.
		 *
		 */
		public function deleteStatus(id:String):void
		{
			addProcessor(DELETE_STATUS_REQUEST_URL, processStatus, MicroBlogEvent.DELETE_STATUS_RESULT, MicroBlogErrorEvent.DELETE_STATUS_ERROR);
			var url:String=DELETE_STATUS_REQUEST_URL.replace("$id", id);
			var params:URLVariables = new URLVariables();
			params["_uri"] = url;
			var req:URLRequest = (_useProxy)? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST);
			executeRequest(DELETE_STATUS_REQUEST_URL, req);
		}

		/**
		 * 转发一条微博信息.为防止重复，发布的信息与当前最新信息一样话，将会被忽略.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.REPOST_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogStatus实例.</p>
		 *
		 * @param id 必填参数，转发的微博ID.
		 * @param status 可选参数，要更新的微博信息,信息内容部超过140个汉字.
		 * 
		 * <p>如果没有登录或超过发布上限，将返回错误
		 * 系统将忽略重复发布的信息.每次发布将比较最后一条发布消息，如果一样将被忽略.因此用户不能连续提交相同信息.
		 * </p>
		 */
		public function repostStatus(id:String, status:String=null):void
		{
			addProcessor(REPOST_STATUS_REQUEST_URL, processStatus, MicroBlogEvent.REPOST_STATUS_RESULT, MicroBlogErrorEvent.REPOST_STATUS_ERROR);
			var params:URLVariables=new URLVariables();
			params.id=id;
			if (status && status.length > 0) params.status=encodeMsg(status);
			params["_uri"] = REPOST_STATUS_REQUEST_URL;
			var req:URLRequest= (_useProxy)?getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + REPOST_STATUS_REQUEST_URL, params, URLRequestMethod.POST);
			executeRequest(REPOST_STATUS_REQUEST_URL, req);
		}

		/**
		 * 对一条微博信息进行评论.为防止重复，发布的信息与当前最新信息一样话，将会被忽略.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件
		 * type为<b>MicroBlogEvent.COMMENT_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogComment实例.</p>
		 *
		 * <p>如果没有登录或超过发布上限，将返回错误<br/>
		 * 系统将忽略重复发布的信息.每次发布将比较最后一条发布消息，如果一样将被忽略.因此用户不能连续提交相同信息.</p>
		 *
		 * @param id 必填参数， 要评论的微博ID.
		 * @param comment 必选参数，要更新的微博信息,信息内容部超过140个汉字.
		 * @param cid 选填参数，要评论的评论ID.
		 *
		 */
		public function commentStatus(id:String, comment:String, cid:String="0"):void
		{
			addProcessor(COMMENT_STATUS_REQUEST_URL, processComment, MicroBlogEvent.COMMENT_STATUS_RESULT, MicroBlogErrorEvent.COMMENT_STATUS_ERROR);
			var params:URLVariables=new URLVariables();
			params.id=id;
			if (comment ) params.comment = encodeMsg(comment);
			if (cid.length > 0) params.cid = cid;
			params["_uri"] = COMMENT_STATUS_REQUEST_URL;
			var req:URLRequest= (_useProxy) ? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + COMMENT_STATUS_REQUEST_URL, params, URLRequestMethod.POST);
			executeRequest(COMMENT_STATUS_REQUEST_URL, req);
		}

		/**
		 * 删除评论.注意：只能删除自己发布的信息.
		 *
		 * <p> 如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.DELETE_STATUS_COMMENT_RESULT</b><br/>
		 * result为一个MicroBlogComment实例.</p>
		 *
		 * @param id 必填参数，要删除的微博评论信息ID.
		 *
		 */
		public function deleteComment(id:String):void
		{
			addProcessor(DELETE_COMMENT_REQUEST_URL, processComment, MicroBlogEvent.DELETE_COMMENT_RESULT, MicroBlogErrorEvent.DELETE_COMMENT_ERROR);
			var url:String=DELETE_COMMENT_REQUEST_URL.replace("$id", id);
			var params:URLVariables = new URLVariables();
			params["_uri"] = url;
			var req:URLRequest = (_useProxy) ? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST);
			executeRequest(DELETE_COMMENT_REQUEST_URL, req);
		}

		/**
		 * 对一条微博评论信息进行回复.为防止重复，发布的信息与当前最新信息一样话，将会被忽略.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.REPLY_STATUS_RESULT</b><br/>
		 * result为一个MicroBlogStatus实例.</p>
		 *
		 * @param id 必填参数， 要评论的微博消息ID.
		 * @param comment 必选参数，要更新的微博信息,信息内容部超过140个汉字.
		 * @param cid 必选参数，要评论的评论ID.
		 * 
		 * <p>如果没有登录或超过发布上限，将返回错误
		 * 系统将忽略重复发布的信息.每次发布将比较最后一条发布消息，如果一样将被忽略.因此用户不能连续提交相同信息.
		 * </p>
		 */
		public function replyStatus(id:String, comment:String, cid:String):void
		{
			addProcessor(REPLY_STATUS_REQUEST_URL, processComment, MicroBlogEvent.REPLY_STATUS_RESULT, MicroBlogErrorEvent.REPLY_STATUS_ERROR);
			var params:URLVariables=new URLVariables();
			params.id=id;
			if (comment) params.comment = encodeMsg(comment);
			params.cid = cid;
			params["_uri"] = REPLY_STATUS_REQUEST_URL;
			var req:URLRequest= (_useProxy) ? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + REPLY_STATUS_REQUEST_URL, params, URLRequestMethod.POST);
			executeRequest(REPLY_STATUS_REQUEST_URL, req);
		}
		
		/**
		 * 通知消息清零接口，设置用户的某个新消息的未读数为0，失败时返回false
		 * 可清除的类型数 1：评论数， 2：&#64;数， 3：私信数，4：关注我的数
		 * @param	type	要清除的技术类别
		 */
		public function resetCount(type:int):void
		{
			if (!(type == 1 || type == 2 || type == 3 || type == 4)) return;
			addProcessor(RESET_STATUS_COUNT_REQUEST_URL, processBooleanResult, MicroBlogEvent.RESET_STATUS_COUNT_RESULT, MicroBlogErrorEvent.RESET_STATUS_COUNT_ERROR);
			var params:URLVariables = new URLVariables();
			params.type = type;
			params["_uri"] = RESET_STATUS_COUNT_REQUEST_URL;
			var req:URLRequest= (_useProxy) ? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + RESET_STATUS_COUNT_REQUEST_URL, params, URLRequestMethod.POST);
			executeRequest(RESET_STATUS_COUNT_REQUEST_URL, req);	
		}

		/**
		 * 按用户UID或昵称返回用户资料，同时也将返回用户的最新发布的微博.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.SHOW_USERS_RESULT</b><br/>
		 * result为一个MicroBlogUser实例.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 指定用户UID,主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 *
		 * <br/>
		 * <b>以上三个参数必须至少给一个</b>
		 * 为了保护用户隐私，只有用户设置了公开或对粉丝设置了公开的数据才会返回.
		 */
		public function loadUserInfo(user:String=null, userID:String="0", screenName:String=null):void
		{
			addProcessor(LOAD_USER_INFO_REQUEST_URL, processUser, MicroBlogEvent.LOAD_USER_INFO_RESULT, MicroBlogErrorEvent.LOAD_USER_INFO_ERROR);
			if (user && user.length > 0) user="/" + user;
			else user="";
			var url:String=LOAD_USER_INFO_REQUEST_URL.replace("$user", user);
			var params:Object=new Object();
			makeUserParams(params, userID, screenName, -1, verifier);		
			params["_uri"] = url;
			if(_useProxy) executeRequest(LOAD_USER_INFO_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(LOAD_USER_INFO_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}

		/**
		 * 返回用户关注实例列表，并返回最新微博文章.按关注人的关注时间倒序返回，
		 * 每次返回100个,通过cursor参数来取得多于100的关注人.
		 * 也可以通过ID,nickname,user_id参数来获取其他人的关注人列表.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.FRIENDS_RESULT</b><br/>
		 * result为一个MicroBlogUser数组.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 指定用户UID,主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 * @param cursor 选填参数. 单页只能包含100个关注列表，为了获取更多则cursor默认从-1开始，通过增加或减少cursor来获取更多的关注列表.
		 *
		 * <p>为了保护用户隐私，只有用户设置了公开或对粉丝设置了公开的数据才会返回.</p>
		 */
		public function loadFriendsInfo(user:String=null, userID:String="0", screenName:String=null, cursor:Number=-1):void
		{
			addProcessor(LOAD_FRIENDS_INFO_REQUEST_URL, processUserArray, MicroBlogEvent.LOAD_FRIENDS_INFO_RESULT, MicroBlogErrorEvent.LOAD_FRIENDS_INFO_ERROR);
			if (user && user.length > 0) user="/" + user;
			else user = "";
			var url:String=LOAD_FRIENDS_INFO_REQUEST_URL.replace("$user", user);
			var params:Object=new Object();
			makeUserParams(params, userID, screenName, cursor);
			params["_uri"] = url;
			if(_useProxy) executeRequest(LOAD_FRIENDS_INFO_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(LOAD_FRIENDS_INFO_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}

		/**
		 * 返回用户的粉丝列表，并返回粉丝的最新微博.按粉丝的关注时间倒序返回，
		 * 每次返回100个,通过cursor参数来取得多于100的粉丝.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.FOLLOWERS_RESULT</b><br/>
		 * result为一个MicroBlogUser数组.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 指定用户UID,主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 * @param cursor 选填参数. 单页只能包含100个关注列表，为了获取更多则cursor默认从-1开始，通过增加或减少cursor来获取更多的关注列表.
		 *
		 * <p>为了保护用户隐私，只有用户设置了公开或对粉丝设置了公开的数据才会返回.</p>
		 */
		public function loadFollowersInfo(user:String=null, userID:String="0", screenName:String=null, cursor:int=-1):void
		{
			addProcessor(LOAD_FOLLOWERS_INFO_REQUEST_URL, processUserArray, MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, MicroBlogErrorEvent.LOAD_FOLLOWERS_INFO_ERROR);
			if (user && user.length > 0) user="/" + user;
			else user = "";
			var url:String=LOAD_FOLLOWERS_INFO_REQUEST_URL.replace("$user", user);
			var params:Object=new Object();
			makeUserParams(params, userID, screenName, cursor);
			params["_uri"] = url;
			if(_useProxy) executeRequest(LOAD_FOLLOWERS_INFO_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(LOAD_FOLLOWERS_INFO_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}

		/**
		 * 返回用户的最新n条私信.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p> 如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.DIRECT_MESSAGES_RESULT</b><br/>
		 * result为一个MicroBlogDirectMessage数组.</p>
		 *
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 *
		 * <p>为了保护用户隐私，只有用户设置了公开或对粉丝设置了公开的数据才会返回.</p>
		 */
		public function loadDirectMessagesReceived(sinceID:String="0", maxID:String="0", count:uint=0, page:uint=0):void
		{
			addProcessor(LOAD_DIRECT_MESSAGES_RECEIVED_REQUEST_URL, processDirectMessageArray, MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, MicroBlogErrorEvent.LOAD_DIRECT_MESSAGES_RECEIVED_ERROR);
			var url:String=LOAD_DIRECT_MESSAGES_RECEIVED_REQUEST_URL;
			var params:Object=new Object();
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			params["_uri"] = LOAD_DIRECT_MESSAGES_RECEIVED_REQUEST_URL;
			if(_useProxy) executeRequest(LOAD_DIRECT_MESSAGES_RECEIVED_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(LOAD_DIRECT_MESSAGES_RECEIVED_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + LOAD_DIRECT_MESSAGES_RECEIVED_REQUEST_URL, params, URLRequestMethod.POST));
		}

		/**
		 * 返回登录用户已发送最新n条私信.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p> 如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.SENT_DIRECT_MESSAGES_RESULT</b><br/>
		 * result为一个MicroBlogDirectMessage数组.</p>
		 *
		 * @param sinceID 请求大于该id的所有消息更新，默认值为0，表示不限制.
		 * @param maxID 请求小于该id的所有消息更新，默认为0，表示不限制.
		 * @param count 请求的页大小，即一页包含多少条记录；默认值0，表示使用服务器默认分页大小.
		 * @param page 请求的页序号，默认值0，返回第一页.
		 *
		 * <p>为了保护用户隐私，只有用户设置了公开或对粉丝设置了公开的数据才会返回.</p>
		 */
		public function loadDirectMessagesSent(sinceID:String="0", maxID:String="0", count:uint=0, page:uint=0):void
		{
			addProcessor(LOAD_DIRECT_MESSAGES_SENT_REQUEST_URL, processDirectMessageArray, MicroBlogEvent.LOAD_DIRECT_MESSAGES_SENT_RESULT, MicroBlogErrorEvent.LOAD_DIRECT_MESSAGES_SENT_ERROR);
			var url:String=LOAD_DIRECT_MESSAGES_SENT_REQUEST_URL;
			var params:Object=new Object();
			makeQueryCombinatory(params, sinceID, maxID, count, page);
			params["_uri"] = LOAD_DIRECT_MESSAGES_SENT_REQUEST_URL;
			if(_useProxy) executeRequest(LOAD_DIRECT_MESSAGES_SENT_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(LOAD_DIRECT_MESSAGES_SENT_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + LOAD_DIRECT_MESSAGES_SENT_REQUEST_URL, params, URLRequestMethod.POST));
		}

		/**
		 * 返发送一条私信.必须包含参数user和message,
		 * userID和screenName必须选一个.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.NEW_DIRECT_MESSAGES_RESULT</b><br/>
		 * result为一个MicroBlogDirectMessage实例.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param message 必须参数. 要发生的消息内容，文本大小必须小于140个汉字.
		 * @param userID 指定用户UID,主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 *
		 */
		public function sendDirectMessage(user:String, message:String, userID:String="0", screenName:String=null):void
		{
			addProcessor(SEND_DIRECT_MESSAGE_REQUEST_URL, processDirectMessage, MicroBlogEvent.SEND_DIRECT_MESSAGE_RESULT, MicroBlogErrorEvent.SEND_DIRECT_MESSAGE_ERROR);
			var params:URLVariables=new URLVariables();
			if (userID.length > 0) params.user_id = userID;
			if (screenName) params.screen_name = screenName;
			params.id = user;
			params.text = encodeMsg(message);		
			params["_uri"] = SEND_DIRECT_MESSAGE_REQUEST_URL;		
			var req:URLRequest=(_useProxy) ? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + SEND_DIRECT_MESSAGE_REQUEST_URL, params, URLRequestMethod.POST);
			executeRequest(SEND_DIRECT_MESSAGE_REQUEST_URL, req);
		}

		/**
		 * 按ID删除私信.操作用户必须为私信的接收人.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.DELETE_DIRECT_MESSAGES_RESULT</b><br/>
		 * result为一个MicroBlogDirectMessage实例.</p>
		 *
		 * @param id 必填参数，要删除的私信主键ID.
		 *
		 */
		public function deleteDirectMessage(id:String):void
		{
			addProcessor(DELETE_DIRECT_MESSAGE_REQUEST_URL, processDirectMessage, MicroBlogEvent.DELETE_DIRECT_MESSAGE_RESULT, MicroBlogErrorEvent.DELETE_DIRECT_MESSAGE_ERROR);
			var url:String=DELETE_DIRECT_MESSAGE_REQUEST_URL.replace("$id", id);
			var params:URLVariables = new URLVariables();
			params["_uri"] = url;	
			var req:URLRequest = (_useProxy) ? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST);
			executeRequest(DELETE_DIRECT_MESSAGE_REQUEST_URL, req);
		}

		/**
		 * 关注一个用户.成功则返回关注人的资料，
		 * 失败则返回一条字符串的说明.
		 *
		 * <p> 如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.CREATE_FRIENDSHIPS_RESULT</b><br/>
		 * result为一个MicroBlogUser实例.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 * @param isFollow 可选参数.将是自己粉丝的用户加为关注.
		 *
		 */
		public function follow(user:String=null, userID:String="0", screenName:String=null, isFollow:Boolean=true):void
		{
			addProcessor(FOLLOW_REQUEST_URL, processUser, MicroBlogEvent.FOLLOW_RESULT, MicroBlogErrorEvent.FOLLOW_ERROR);
			if (user && user.length > 0) user="/" + user;
			else user = "";
			var url:String=FOLLOW_REQUEST_URL.replace("$user", user);
			var params:URLVariables=new URLVariables();
			if (userID.length > 0) params.user_id = userID;
			if (screenName && screenName.length > 0) params.screen_name = screenName;;
			params.follow = isFollow;
			params["_uri"] = url;	
			
			var req:URLRequest=(_useProxy) ? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST);
			executeRequest(FOLLOW_REQUEST_URL, req);
		}

		/**
		 * 取消关注某用户.成功则返回被取消关注人的资料，
		 * 失败则返回一条字符串的说明.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.DESTROY_FRIENDSHIPS_RESULT</b><br/>
		 * result为一个MicroBlogUser实例.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 *
		 */
		public function cancelFollowing(user:String=null, userID:String="0", screenName:String=null):void
		{
			addProcessor(CANCEL_FOLLOWING_REQUEST_URL, processUser, MicroBlogEvent.CANCEL_FOLLOWING_RESULT, MicroBlogErrorEvent.CANCEL_FOLLOWING_ERROR);
			if (user && user.length > 0) user = "/" + user;
			else user = "";
			var url:String=CANCEL_FOLLOWING_REQUEST_URL.replace("$user", user);
			var params:URLVariables=new URLVariables();
			if ( userID.length > 0 ) params.user_id = userID;
			if ( screenName && screenName.length > 0 ) params.screen_name = screenName;
			params["_uri"] = url;	
			var req:URLRequest=(_useProxy) ? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST);
			executeRequest(CANCEL_FOLLOWING_REQUEST_URL, req);
		}

		/**
		 * 返回两个用户关系的详细情况.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.CHECK_FRIENDSHIPS_RESULT</b><br/>
		 * result为<code>MicroBlogUsersRelationship</code>值.</p>
		 *
		 * @param targetID 			选填参数，要判断的目标用户的uid.
		 * @param targetScreenName  选填参数，要判断的目标用户的昵称.targetID和targetScreenName两个参数必须填一个.
		 * @param sourceID 			选填参数，要判断的源用户的uid
		 * @param sourceScreenName 	选填参数，要判断的源用户的昵称.如果sourceID和sourceScreenName两个参数必须填一个(线上接口文档有误）.
		 *
		 */
		public function checkIsFollowing(targetID:String = "0", targetScreenName:String=null, sourceID:String="0", sourceScreenName:String=null):void
		{
			addProcessor(CHECK_IS_FOLLOWING_REQUEST_URL, processRelationship, MicroBlogEvent.CHECK_IS_FOLLOWING_RESULT, MicroBlogErrorEvent.CHECK_IS_FOLLOWING_ERROR);
			var params:Object=new Object();
			var needExecute:Boolean=false;
			if (targetID.length > 0 && targetID != "0")
			{
				params[TARGET_ID]=targetID;
				needExecute=true;
			}
			if (targetScreenName && targetScreenName.length > 0)
			{
				params[TARGET_SCREEN_NAME]=StringEncoders.urlEncodeUtf8String(targetScreenName);
				needExecute=true;
			}
			if (!needExecute)
			{
				return;
			}
			if (sourceID.length > 0 && sourceID != "0")
			{
				params[SOURCE_ID]=sourceID;
			}
			if (sourceScreenName && sourceScreenName.length > 0)
			{
				params[SOURCE_SCREEN_NAME]=StringEncoders.urlEncodeUtf8String(sourceScreenName);
			}
			var url:String = CHECK_IS_FOLLOWING_REQUEST_URL;
			params["_uri"] = url;	
			if(_useProxy) executeRequest(CHECK_IS_FOLLOWING_REQUEST_URL,getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(CHECK_IS_FOLLOWING_REQUEST_URL,getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}

		/**
		 * 返回用户关注对象的user_id列表.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.LOAD_FRIENDS_ID_LIST_RESULT</b><br/>
		 * result为<code>uint数组</code>实例.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.LOAD_FRIENDS_ID_LIST_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 * @param cursor 选填参数. 单页只能包含5000个id，为了获取更多则cursor默认从-1开始，通过增加或减少cursor来获取更多的关注列表.
		 * @param count 可选参数. 每次返回的最大记录数（即页面大小），不大于5000。
		 */
		public function loadFriendsIDList(user:String=null, userID:String="0", screenName:String=null, cursor:Number=-1, count:uint=5000):void
		{
			addProcessor(LOAD_FRIENDS_ID_LIST_REQUEST_URL, processIDSArray, MicroBlogEvent.LOAD_FRIENDS_ID_LIST_RESULT, MicroBlogErrorEvent.LOAD_FRIENDS_ID_LIST_ERROR);
			if (user && user.length > 0)
			{
				user="/" + user;
			}else{
				user="";
			}
			var url:String=LOAD_FRIENDS_ID_LIST_REQUEST_URL.replace("$user", user);
			var params:Object=new Object();
			makeUserParams(params, userID, screenName, cursor);
			params["count"] = count;
			params["_uri"] = url;
			if(_useProxy) executeRequest(LOAD_FRIENDS_ID_LIST_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(LOAD_FRIENDS_ID_LIST_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}

		/**
		 * 返回用户粉丝的user_id列表.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.LOAD_FOLLOWERS_ID_LIST_RESULT</b><br/>
		 * result为<code>uint数组</code>实例.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.LOAD_FOLLOWERS_ID_LIST_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param user 用户UID或用户帐号.
		 * @param userID 主要是用来区分用户UID跟用户账号一样，产生歧义的时候，特别是在用户账号为数字导致和用户Uid发生歧义.
		 * @param screenName 指定微博昵称，主要是用来区分用户UID跟用户账号一样，产生歧义的时候.
		 * @param cursor 选填参数. 单页只能包含5000个id，为了获取更多则cursor默认从-1开始，通过增加或减少cursor来获取更多的关注列表.
		 * @param count 可选参数. 每次返回的最大记录数（即页面大小），不大于5000。
		 */
		public function loadFollowersIDList(user:String=null, userID:String="0", screenName:String=null, cursor:Number=-1, count:uint=5000):void
		{
			addProcessor(LOAD_FOLLOWERS_ID_LIST_REQUEST_URL, processIDSArray, MicroBlogEvent.LOAD_FOLLOWERS_ID_LIST_RESULT, MicroBlogErrorEvent.LOAD_FOLLOWERS_ID_LIST_ERROR);
			if (user && user.length>0)
			{
				user="/" + user;
			}
			else
			{
				user="";
			}
			var url:String=LOAD_FOLLOWERS_ID_LIST_REQUEST_URL.replace("$user", user);
			var params:Object=new Object();
			makeUserParams(params, userID, screenName, cursor);
			params["count"] = count;
			params["_uri"] = url;
			if(_useProxy) executeRequest(LOAD_FOLLOWERS_ID_LIST_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(LOAD_FOLLOWERS_ID_LIST_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST));
		}

		/**
		 * 判断用户身份是否合法.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.VERIFY_CREDENTIALS_RESULT</b><br/>
		 * result为<code>MicroBlogUser</code>实例.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.VERIFY_CREDENTIALS_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 */
		public function verifyCredentials():void
		{
			addProcessor(VERIFY_CREDENTIALS_REQUEST_URL, processUser, MicroBlogEvent.VERIFY_CREDENTIALS_RESULT, MicroBlogErrorEvent.VERIFY_CREDENTIALS_ERROR);
			var params:Object = new Object();	
			params["_uri"] = VERIFY_CREDENTIALS_REQUEST_URL;
			if(_useProxy) executeRequest(VERIFY_CREDENTIALS_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));	
			else executeRequest(VERIFY_CREDENTIALS_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + VERIFY_CREDENTIALS_REQUEST_URL, params, URLRequestMethod.POST));	
		}

		/**
		 * 获取当前的API调用次数限制.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.RATE_LIMIT_INFO_RESULT</b><br/>
		 * result为<code>MicroBlogRateInfo</code>实例.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.RATE_LIMIT_INFO_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 */
		public function getRateLimitInfo():void
		{
			addProcessor(GET_RATE_LIMIT_STATUS_REQUEST_URL, processRateLimit, MicroBlogEvent.GET_RATE_LIMIT_STATUS_RESULT, MicroBlogErrorEvent.GET_RATE_LIMIT_STATUS_ERROR);
			var params:Object = new Object();	
			params["_uri"] = GET_RATE_LIMIT_STATUS_REQUEST_URL;			
			if(_useProxy) executeRequest(GET_RATE_LIMIT_STATUS_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(GET_RATE_LIMIT_STATUS_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + GET_RATE_LIMIT_STATUS_REQUEST_URL, params, URLRequestMethod.POST));
		}

		/**
		 * 登陆用户退出.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.LOGOUT_RESULT</b><br/></p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.LOGOUT_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 */
		public function logout():void
		{
			//curl -u user:password -d "" http://api.t.sina.com.cn/account/end_session.xml
			addProcessor(LOGOUT_REQUEST_URL, processLogout, MicroBlogEvent.LOGOUT_RESULT, MicroBlogErrorEvent.LOGOUT_ERROR);
			var params:URLVariables = new URLVariables();
			params["_uri"] = LOGOUT_REQUEST_URL;	
			var req:URLRequest = (_useProxy) ? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + LOGOUT_REQUEST_URL, params, URLRequestMethod.POST);
			executeRequest(LOGOUT_REQUEST_URL, req );
		}

		/**
		 * 用户可以通过此接口来更新头像.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.UPDATE_PROFILE_IMAGE_RESULT</b><br/>
		 * result为一个MicroBlogUser实例.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.UPDATE_PROFILE_IMAGE_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param imgData  必须为小于700K的有效的GIF, JPG, 或 PNG 图片. 如果图片大于500像素将按比例缩放
		 *
		 */
		public function updateProfileImage(imgData:ByteArray, filename:String):void
		{
			addProcessor(UPDATE_PROFILE_IMAGE_REQUEST_URL, processUser, MicroBlogEvent.UPDATE_PROFILE_IMAGE_RESULT, MicroBlogErrorEvent.UPDATE_PROFILE_IMAGE_ERROR);
			var params:Object = { };
			var tempParams:Object = { }; ///////////////////////////////////////////////////// PROXY_URL接口有个bug，后端开发朱磊（6587/zhulei@staff.sina.com.cn）要求此方法请求
			tempParams["_uri"] = UPDATE_PROFILE_IMAGE_REQUEST_URL;
			tempParams["source"] = source;
			tempParams["_method"] = URLRequestMethod.POST;
			tempParams["_cache_time"] = "0";
			tempParams["_anywhereToken"] = _anywhereToken;
			var req:URLRequest = (_useProxy) ? new URLRequest(PROXY_URL + makeGETParamString(tempParams)) : new URLRequest(API_BASE_URL + UPDATE_PROFILE_IMAGE_REQUEST_URL + makeGETParamString(tempParams));
			
			if ( accessTokenKey.length > 0)
			{
				req=signRequest(URLRequestMethod.POST, UPDATE_PROFILE_IMAGE_REQUEST_URL, params, false);
			}else{
				if ( authHeader ) req.requestHeaders.push(authHeader);
			}			
			
			req.method = URLRequestMethod.POST;	
			params.source = source;			
			var boundary:String=makeBoundary();
			req.contentType = MULTIPART_FORMDATA + boundary;		
			req.data=makeMultipartPostData(boundary, "image", filename, imgData, params);
			executeRequest(UPDATE_PROFILE_IMAGE_REQUEST_URL, req);
		}

		/**
		 * 用户可以通过此接口来更改微博信息的来源.用于无法传递ByteArray为参数的情况.
		 *
		 * <p>如果图片上传成功，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.UPDATE_DELIVERY_DEVICE_RESULT</b><br/>
		 * result为一个MicroBlogUser实例.</p>
		 *
		 * <p>如果图片上传失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.UPDATE_DELIVERY_DEVICE_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @return 返回用于上传图片的URLRequest.用于在flash中用File对象上传图片，在调用File对象的upload时uploadDataFieldName必须为image
		 *
		 */
		public function getUpdateProfileImageRequest():URLRequest
		{
			var params:URLVariables = new URLVariables();
			params["_uri"] = UPDATE_PROFILE_IMAGE_REQUEST_URL;
			var req:URLRequest=(_useProxy) ? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + UPDATE_PROFILE_IMAGE_REQUEST_URL, params, URLRequestMethod.POST);
			return req;
		}

		/**
		 * 用户可以通过此接口来更新微博页面参数,只会修改参数更新项。 
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.UPDATE_PROFILE_RESULT</b><br/>
		 * result为一个MicroBlogUser实例.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.UPDATE_PROFILE_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param params MicroBlogProfileUpdateParams对象，用于更新个人设置@see com.sina.microblog.data.MicroBlogProfileUpdateParams
		 */
		public function updateProfile(params:MicroBlogProfileUpdateParams):void
		{
			addProcessor(UPDATE_PROFILE_REQUEST_URL, processUser, MicroBlogEvent.UPDATE_PROFILE_RESULT, MicroBlogErrorEvent.UPDATE_PROFILE_ERROR);
			if (null==params || params.isEmpty)
			{
				return;
			}
			var postData:URLVariables = params.postData;
			postData["_uri"] = UPDATE_PROFILE_REQUEST_URL;
			var req:URLRequest=(_useProxy) ? getMicroBlogRequest(PROXY_URL, postData, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + UPDATE_PROFILE_REQUEST_URL, postData, URLRequestMethod.POST);
			executeRequest(UPDATE_PROFILE_REQUEST_URL, req);
		}

		/**
		 * 返回用户的最近20条收藏信息，和用户收藏页面返回内容是一致的.
		 *
		 * <b>有请求数限制</b>
		 * 
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.LOAD_FAVORIT_LIST_RESULT</b><br/>
		 * result为一个MicroBlogStatus对象数组.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.LOAD_FAVORIT_LIST_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param page  可选参数. 返回结果的页序号。注意：有分页限制.
		 */
		public function loadFavoriteList(page:uint=0):void
		{
			addProcessor(LOAD_FAVORITE_LIST_REQUEST_URL, processStatusArray, MicroBlogEvent.LOAD_FAVORITE_LIST_RESULT, MicroBlogErrorEvent.LOAD_FAVORITE_LIST_ERROR);	
			var url:String=LOAD_FAVORITE_LIST_REQUEST_URL;
			var params:Object=new Object();
			if ( page > 0 )
			{
				params["page"]=page.toString();
			}
			params["_uri"] = LOAD_FAVORITE_LIST_REQUEST_URL;
			if(_useProxy) executeRequest(LOAD_FAVORITE_LIST_REQUEST_URL, getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST));
			else executeRequest(LOAD_FAVORITE_LIST_REQUEST_URL, getMicroBlogRequest(API_BASE_URL + LOAD_FAVORITE_LIST_REQUEST_URL, params, URLRequestMethod.POST));
		}

		/**
		 * 收藏一条微博信息.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.ADD_TO_FAVORITES_RESULT</b><br/>
		 * result为一个MicroBlogStatus对象.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.ADD_TO_FAVORITES_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param statusID 必填参数， 要收藏的微博id.
		 *
		 */
		public function addToFavorites(statusID:String):void
		{
			if ( statusID == "" )
			{
				return;
			}
			addProcessor(ADD_TO_FAVORITES_REQUEST_URL, processStatus, MicroBlogEvent.ADD_TO_FAVORITES_RESULT, MicroBlogErrorEvent.ADD_TO_FAVORITES_ERROR);

			var params:URLVariables=new URLVariables();
			params.id = statusID.toString();
			params["_uri"] = ADD_TO_FAVORITES_REQUEST_URL;
			var req:URLRequest=(_useProxy) ? getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST) : getMicroBlogRequest(API_BASE_URL + ADD_TO_FAVORITES_REQUEST_URL, params, URLRequestMethod.POST);
			executeRequest(ADD_TO_FAVORITES_REQUEST_URL, req);
		}

		/**
		 * 从收藏列表里删除一条微博信息.
		 *
		 * <p>如果该函数被成功执行，将会抛出MicroBlogEvent事件，该事件<br/>
		 * type为<b>MicroBlogEvent.ADD_TO_FAVORITES_RESULT</b><br/>
		 * result为一个MicroBlogStatus对象.</p>
		 *
		 * <p>如果该函数调用失败，将会抛出MicroBlogErrorEvent事件，该事件<br/>
		 * type为<b>MicroErrorEvent.ADD_TO_FAVORITES_ERROR</b><br/>
		 * message为错误描述.</p>
		 *
		 * @param statusID 必填参数， 要收藏的微博id.
		 *
		 */
		public function removeFromFavorites(statusID:uint):void
		{
			if ( statusID <= 0)
			{
				return;
			}
			addProcessor(REMOVE_FROM_FAVORITES_REQUEST_URL, processStatus, MicroBlogEvent.REMOVE_FROM_FAVORITES_RESULT, MicroBlogErrorEvent.REMOVE_FROM_FAVORITES_ERROR);
			var params:URLVariables = new URLVariables();
			var url:String = REMOVE_FROM_FAVORITES_REQUEST_URL.replace("$id", statusID);
			params["_uri"] = url;
			var req:URLRequest=(_useProxy)?getMicroBlogRequest(PROXY_URL, params, URLRequestMethod.POST):getMicroBlogRequest(API_BASE_URL + url, params, URLRequestMethod.POST);
			executeRequest(REMOVE_FROM_FAVORITES_REQUEST_URL, req);
		}
		
		private function addProcessor(name:String, dataProcess:Function, resultEventType:String, errorEventType:String):void
		{
			if (null == serviceLoader[name])
			{
				var loader:URLLoader=new URLLoader();
				loader.addEventListener(Event.COMPLETE, loader_onComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, loader_onError);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_onSecurityError);
				serviceLoader[name]=loader;
				loaderMap[loader]={dataFunc: dataProcess, resultEvent: resultEventType, errorEvent: errorEventType};
			}
		}
		
		private function executeRequest(name:String, req:URLRequest):void
		{
			var urlLoader:URLLoader = serviceLoader[name] as URLLoader;
			urlLoader.load(req);
		}

		private function loader_onComplete(event:Event):void
		{
			var loader:URLLoader=event.target as URLLoader;
			var processor:Object=loaderMap[loader];
			var dataStr:String = loader.data as String;
			if ( dataStr.length  <= 0 )
			{
				var ioError:MicroBlogErrorEvent = new MicroBlogErrorEvent(MicroBlogErrorEvent.NET_WORK_ERROR);
				ioError.message = "The network error";
				dispatchEvent(ioError);
				return;
			}		
			var result:XML=new XML(loader.data);
			if (result.child("error").length() > 0)
			{
				var error:MicroBlogErrorEvent=new MicroBlogErrorEvent(processor.errorEvent);
				error.message="Error " + result.error_code + " : " + result.error;
				dispatchEvent(error);
			}
			else
			{
				var e:MicroBlogEvent=new MicroBlogEvent(processor.resultEvent);
				e.result=processor.dataFunc(result);
				e.nextCursor=Number(result.next_cursor);
				e.previousCursor=Number(result.previous_cursor);
				dispatchEvent(e);
			}
		}

		private function loader_onError(event:IOErrorEvent):void
		{
			var loader:URLLoader=event.target as URLLoader;
			var processor:Object=loaderMap[loader];
			var error:MicroBlogErrorEvent=new MicroBlogErrorEvent(processor.errorEvent);
			error.message=event.text;
			dispatchEvent(error);
		}

		private function loader_onSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}

		private function getMicroBlogRequest(url:String, params:Object, requestMethod:String="GET"):URLRequest
		{
			var req:URLRequest;		
			if ( null == params )
			{
				params = {};
			}
			params["source"] = source;
			params["_method"] = requestMethod;
			params["_cache_time"] = "0";
			params["_anywhereToken"] = _anywhereToken;
			if ( accessTokenKey.length > 0)
			{
				req=signRequest(requestMethod, url, params, false);
			}else{
				if (requestMethod == URLRequestMethod.GET)
				{
					url+=makeGETParamString(params);
				}
				req = new URLRequest(url);
				if (requestMethod == URLRequestMethod.POST)
				{
					var val:URLVariables = new URLVariables();
					for (var key:* in params)
					{
						val[key] = params[key];
					}
					req.data = val;
				}
				if ( authHeader )
				{
					req.requestHeaders.push(authHeader);
				}
			}
			req.method=requestMethod;
			return req;
		}
		
		private function processGeneralApi(rawData:XML):XML
		{
			return rawData;
		}

		private function processStatusArray(statuses:XML):Array
		{
			var microBlogStatus:MicroBlogStatus;
			var statusArray:Array=[];
			for each (var status:XML in statuses.status)
			{
				microBlogStatus=new MicroBlogStatus(status);
				statusArray.push(microBlogStatus);
			}
			return statusArray;
		}

		private function processStatus(status:XML):MicroBlogStatus
		{
			return new MicroBlogStatus(status);
		}

		private function processCommentArray(comments:XML):Array
		{
			var microBlogComment:MicroBlogComment;
			var commentArray:Array=[];
			for each (var comment:XML in comments.comment)
			{
				microBlogComment=new MicroBlogComment(comment);
				commentArray.push(microBlogComment);
			}
			return commentArray;
		}

		private function processComment(comment:XML):MicroBlogComment
		{
			return new MicroBlogComment(comment);
		}

		private function processCounts(counts:XML):Array
		{
			var countArray:Array=[];
			var count:MicroBlogCount;
			for each (var countValue:XML in counts.children())
			{
				count=new MicroBlogCount(countValue);
				countArray.push(count);
			}
			return countArray;
		}
		
		private function processUnread(data:XML):MicroBlogUnread
		{
			return new MicroBlogUnread(data);
		}

		private function processUser(user:XML):MicroBlogUser
		{
			return new MicroBlogUser(user);
		}

		private function processUserArray(users:XML):Array
		{
			var userArray:Array=[];
			var mbUser:MicroBlogUser;
			for each (var userValue:XML in users.user)
			{
				mbUser=new MicroBlogUser(userValue);
				userArray.push(mbUser);
			}
			return userArray;
		}

		private function processDirectMessageArray(messages:XML):Array
		{
			var messageArray:Array=[];
			var mbMessage:MicroBlogDirectMessage;
			for each (var messageValue:XML in messages.direct_message)
			{
				mbMessage=new MicroBlogDirectMessage(messageValue);
				messageArray.push(mbMessage);
			}
			return messageArray;
		}

		private function processDirectMessage(message:XML):MicroBlogDirectMessage
		{
			return new MicroBlogDirectMessage(message);
		}
		
		private function processRelationship(message:XML):MicroBlogUsersRelationship
		{
			return new MicroBlogUsersRelationship(message);
		}

		private function processIDSArray(message:XML):Array
		{
			var ar:Array=[];
			for each (var id:XML in message.ids[0].children())
			{
				ar.push(uint(id.toString()));
			}
			return ar;
		}
		
		private function processRateLimit(message:XML):MicroBlogRateLimit
		{
			return new MicroBlogRateLimit(message);
		}
		
		private function processLogout(user:XML):MicroBlogUser
		{
			_accessTokenKey = "";
			_accessTokenSecret = "";
			authHeader = null;
			_anywhereToken = "";
			return new MicroBlogUser(user);
		}
		
		private function processBooleanResult(result:XML):Boolean
		{
			return String(result[0]) == "true";
		}
		
		private function processProvincesXML(result:XML):XML
		{
			return result;
		}
		
		private function makeGETParamString(parameters:Object):String
		{
			var paramStr:String=makeParamsToUrlString(parameters);
			if (paramStr.length > 0)
			{
				paramStr="?" + paramStr;
			}
			return paramStr;
		}

		private function makeQueryCombinatory(params:Object, sinceID:String, maxID:String, count:uint, page:uint):void
		{
			if (sinceID.length > 0)
			{
				params[SINCE_ID]=sinceID;
			}
			if (maxID.length > 0)
			{
				params[MAX_ID]=maxID;
			}
			if (count > 0)
			{
				params[COUNT]=count;

			}
			if (page > 0)
			{
				params[PAGE]=page;
			}
		}

		private function makeUserParams(params:Object, userID:String, screenName:String, cursor:Number, verify:String = ""):void
		{
			if (userID.length > 0 && userID != "0") params[USER_ID] = userID;			
			if (screenName) params[SCREEN_NAME] = screenName;			
			if (cursor >= 0) params[CURSOR] = cursor;			
			if (verify != "") params[VERIFIER] = verify;
		}

		private function makeBoundary():String
		{
			var boundary:String="";
			for (var i:int=0; i < 13; i++)
			{
				boundary+=String.fromCharCode(int(97 + Math.random() * 25));
			}
			boundary="---------------------------" + boundary;
			return boundary;
		}

		private function encodeMsg(status:String):String
		{
			return StringEncoders.urlEncodeSpecial(status);
		}

		private function makeMultipartPostData(boundary:String, imgFieldName:String, filename:String, imgData:ByteArray, params:Object):Object
		{
			var req:URLRequest=new URLRequest();
			var postData:ByteArray=new ByteArray();
			postData.endian=Endian.BIG_ENDIAN;
			var value:String;
			//add params to the post data.
			if (params)
			{
				for (var name:String in params)
				{
					boundaryPostData(postData, boundary);
					addLineBreak(postData);
					//writeStringToByteArray(postData, CONTENT_DISPOSITION_BASIC.replace("$name", name));
					postData.writeUTFBytes(CONTENT_DISPOSITION_BASIC.replace("$name", name));
					addLineBreak(postData);
					addLineBreak(postData);
					postData.writeUTFBytes(params[name]);
					addLineBreak(postData);
				}
			}
			//add image;
//			--BbC04y
//			Content-Disposition: file; filename="file2.jpg"
//			Content-Type: image/jpeg
//			Content-Transfer-Encoding: binary
//			
//			...contents of file2.jpg...
//			--BbC04y--

			boundaryPostData(postData, boundary);
			addLineBreak(postData);
			//writeStringToByteArray(postData, CONTENT_DISPOSITION_BASIC.replace("$name", "files") + '; filename="'+filename + '"');
			postData.writeUTFBytes(CONTENT_DISPOSITION_BASIC.replace("$name", imgFieldName) + '; filename="' + filename + '"');
			addLineBreak(postData);
			//writeStringToByteArray(postData, CONTENT_TYPE_JPEG);
			postData.writeUTFBytes(CONTENT_TYPE_JPEG);
			addLineBreak(postData);
			//writeStringToByteArray(postData,CONTENT_TRANSFER_ENCODING);
			//postData.writeUTFBytes(CONTENT_TRANSFER_ENCODING);
			//addLineBreak(postData);
			addLineBreak(postData);
			postData.writeBytes(imgData, 0, imgData.length);
			addLineBreak(postData);

			boundaryPostData(postData, boundary);
			addDoubleDash(postData);

			//trace(postData.toString());
			postData.position=0;
			return postData;
		}

		private function boundaryPostData(data:ByteArray, boundary:String):void
		{
			var len:int=boundary.length;
			addDoubleDash(data);
			for (var i:int=0; i < len; ++i)
			{
				data.writeByte(boundary.charCodeAt(i));
			}
		}

		private function addDoubleDash(data:ByteArray):void
		{
			data.writeShort(0x2d2d);
		}

		private function addLineBreak(data:ByteArray):void
		{
			data.writeShort(0x0d0a);
		}


		private function signRequest(requestMethod:String, url:String, requestParams:Object, useHead:Boolean=false):URLRequest
		{
			var method:String = requestMethod.toUpperCase();
			var oauthParams:Object=getOAuthParams();
			var params:Object = new Object;
			for (var key:String in oauthParams)
			{
				params[key] = oauthParams[key];
			}
			
			for (var key1:String in requestParams)
			{
				params[key1] = requestParams[key1];
			}
			var req:URLRequest=new URLRequest();
			req.method=method;
			req.url=url;
			var paramsStr:String=makeSignableParamStr(params);
			var msgStr:String=StringEncoders.urlEncodeUtf8String(requestMethod.toUpperCase()) + "&";
			msgStr+=StringEncoders.urlEncodeUtf8String(url);
			msgStr+="&";
			msgStr += StringEncoders.urlEncodeUtf8String(paramsStr);
			
			var secrectStr:String = _consumerSecret + "&";
			if (_accessTokenSecret.length > 0 && _accessTokenKey.length > 0)
			{
				secrectStr+=_accessTokenSecret;
			}
			var sig:String=Base64.encode(HMAC.hash(secrectStr, msgStr, SHA1));
			// The matchers are specified in OAuth only.
			sig = sig.replace(/\+/g, "%2B");
			oauthParams["oauth_signature"] = sig;
			
			if (method == URLRequestMethod.GET)
			{
				if (useHead)
				{
					req.url+=("?" + makeSignableParamStr(requestParams));
					req.requestHeaders.push(makeOauthHeaderFromArray(oauthParams));
				}
				else
				{
					req.url+=("?" + paramsStr + '&oauth_signature=' + sig);
				}
			}else if (requestMethod == URLRequestMethod.POST){					
				var val:URLVariables = new URLVariables();
				for (var paramkey:* in params)
				{
					val[paramkey] = params[paramkey];
				}
				val.oauth_signature = sig;
				req.data = val;
			}
			return req;
		}

		private function makeSignableParamStr(params:Object):String
		{
			var retParams:Array=[];

			for (var param:String in params)
			{
				if (param != "oauth_signature")
				{
					retParams.push(param + "=" + StringEncoders.urlEncodeUtf8String(params[param].toString()));
					//retParams.push(param + "=" +params[param].toString());
				}
			}
			retParams.sort();

			return retParams.join("&");
		}

		private function makeParamsToUrlString(params:Object):String
		{
			var retParams:Array=[];

			for (var param:String in params)
			{
				retParams.push(param + "=" + params[param].toString());
			}
			retParams.sort();
			return retParams.join("&");
		}

		private function makeOauthHeaderFromArray(params:Object):URLRequestHeader
		{
			var oauthHeaderValue:String='OAuth realm="' + API_BASE_URL + '/",';
			var parseParams:Array=[];
			for (var key:String in params)
			{
				parseParams.push(key + '="' + params[key] + '"');
			}
			oauthHeaderValue+=parseParams.join(",");

			var reqHeader:URLRequestHeader=new URLRequestHeader("Authorization", oauthHeaderValue);
			return reqHeader;
		}

		private function getOAuthParams():Object
		{
			var params:Object=new Object;
			var now:Date=new Date();

			params["oauth_consumer_key"]=_consumerKey;
			if (_accessTokenKey.length > 0)	params["oauth_token"] = _accessTokenKey;
			if (_pin && _pin.length > 0) params["oauth_verifier"] = _pin;
			params["oauth_signature_method"]="HMAC-SHA1";
			params["oauth_timestamp"]=now.time.toString().substr(0, 10);
			params["oauth_nonce"]=GUID.createGUID();
			params["oauth_version"]="1.0";
			params["oauth_callback"]="oob";
			return params;
		}
		
		private function oauthLoader_onComplete(event:Event):void
		{
			var needRequestAuthorize:Boolean = _accessTokenKey.length == 0;
			var result:String = oauthLoader.data as String;
			if (result.length > 0)
			{
				var urlVar:URLVariables=new URLVariables(oauthLoader.data);
				_accessTokenKey=urlVar.oauth_token;
				_accessTokenSecret=urlVar.oauth_token_secret;
				if (needRequestAuthorize)
				{
					requestAuthorize();
					needRequestAuthorize=false;
				}
				else
				{
					var e:MicroBlogEvent=new MicroBlogEvent(MicroBlogEvent.OAUTH_CERTIFICATE_RESULT);
					e.result={oauthTokenKey: _accessTokenKey, oauthTokenSecrect: _accessTokenSecret};
					dispatchEvent(e);
					verifyCredentials();
				}
			}
		}

		private function oauthLoader_onError(event:IOErrorEvent):void
		{
			var e:MicroBlogErrorEvent = new MicroBlogErrorEvent(MicroBlogErrorEvent.OAUTH_CERTIFICATE_ERROR);
			e.message = oauthLoader.data;
			dispatchEvent(e);
		}

		private function oauthLoader_onSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}

		///弹出pin登录的授权框
		private function requestAuthorize():void
		{
			var url:String=OAUTH_AUTHORIZE_REQUEST_URL;
			url+="?oauth_token=" + StringEncoders.urlEncodeUtf8String(_accessTokenKey);
			url+="&oauth_callback=oob";
			if (ExternalInterface.available) ExternalInterface.call("window.open", url,'newwindow','height=420,width=500,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no, z-look=yes, alwaysRaised=yes');
			else navigateToURL(new URLRequest(url), "_blank");
		}
	}
}