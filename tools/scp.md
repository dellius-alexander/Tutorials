# SCP: Secure Copy via SSh

How to use SCP

- To copy from a (remote) server to your computer
- To copy from your computer to a (remote) server
- To copy from a (remote) server to another (remote) server

In the third case, the data is transferred directly between the servers; your own computer will only tell the servers what to do.

---
---

1. transfer the file “examplefile” to the directory “/home/yourusername/” at the server “yourserver” 

    ```bash
    $ scp examplefile yourusername@yourserver:/home/yourusername/
    ```

2. This will copy the file “/home/yourusername/examplefile” to the current directory on your own computer, provided that the username and password are correct. The `dot` at the end means the current local directory. This is a handy trick that can be used about everywhere in Linux. 
        
    ```bash
    $ scp yourusername@yourserver:/home/yourusername/examplefile .
    ```

3. Note: To make the above command work, the servers must be able to reach each other, as the data will be transferred directly between them.

    ```bash
    $ scp yourusername@yourserver:/home/yourusername/examplefile yourusername2@yourserver2:/home/yourusername2/
    ```

    