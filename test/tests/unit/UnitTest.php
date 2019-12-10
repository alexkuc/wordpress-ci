<?php
class UnitTest extends \Codeception\Test\Unit
{
    /**
     * @var \UnitTester
     */
    protected $tester;

    public function testAssertTrue()
    {
        $this->assertTrue((bool) 1);
    }

    public function testAssertFalse()
    {
        $this->assertFalse((bool) 0);
    }

    public function testAssertObject()
    {
        $this->assertIsObject(new class {});
    }

    public function testAssertArray()
    {
        $this->assertIsArray([1, 2, 3, 4, 5]);
    }

    public function testAssertNull()
    {
        $this->assertNull(null);
    }
}
