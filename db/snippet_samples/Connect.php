<?php

class DBConnect {
    protected static $connection;

    private $dbms;
    private $host;
    private $db;
    private $user;
    private $password;

    private $globals = array();

    public function __construct($dbms, $host, $db, $user, $password) {
        $this->dbms = $dbms;
        $this->host = $host;
        $this->db = $db;
        $this->user = $user;
        $this->password = $password;

        $this->getConnection();
    }

    public function getConnection() {
        if (!self::$connection) {
            try {
                self::$connection = new PDO($this->dbms . ':host=' . $this->host . ';dbname=' . $this->db, $this->user, $this->password);
                self::$connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

                if ($this->dbms == 'mysql')
                    self::$connection->query('SET NAMES utf8');
            } catch (PDOException $e) {
                global $GLOBALS; // not necessary
                $GLOBALS['db_error_bold'] = 'Database error: ';
                $GLOBALS['db_error'] = 'Couldn\'t connect to database';

                return -1;
            }
        }

        return self::$connection;
    }

}