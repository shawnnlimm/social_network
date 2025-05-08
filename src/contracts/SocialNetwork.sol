pragma solidity ^0.5.0;

contract SocialNetwork {
    // State variable
    string public name; // Stored on blockchain unlike local var
    uint public postCount = 0;

    mapping(uint => Post) public posts; // Essentially a hashmap

    struct Post {
        uint id;
        string content;
        uint tipAmount;
        address payable author;
    }

    event PostCreated( // Event that external consumers can subscribe to
        uint id,
        string content,
        uint tipAmount,
        address payable author
    );

    event PostTipped(
        uint id,
        string content,
        uint tipAmount,
        address payable author
    );

    // Constructor
    constructor() public {
        name = "Dapp University Social Network";
    }

    function createPost(string memory _content) public {
        // Require valid content
        require(bytes(_content).length > 0);
        // Increment post count
        postCount++;
        // Create the post
        posts[postCount] = Post(postCount, _content, 0, msg.sender); // msg.sender tells us the user who called the fn
        // Trigger event
        emit PostCreated(postCount, _content, 0, msg.sender);
    }

    function tipPost(uint _id) public payable { // 'payable' keyword allows sending of crypto whenever fn is called
        // Make sure post is valid
        require(_id > 0 && _id <= postCount);
        // Fetch the post
        Post memory _post = posts[_id];
        // Fetch the author
        address payable _author = _post.author;
        // Pay author by sending eth
        address(_author).transfer(msg.value);
        // Increment the tip amount
        _post.tipAmount = _post.tipAmount + msg.value;
        // Update post
        posts[_id] = _post;
        // Trigger event
        emit PostTipped(postCount, _post.content, _post.tipAmount, _author);
     }
}
