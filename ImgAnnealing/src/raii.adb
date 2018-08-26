with Ada.Text_IO;
package body RAII is
   overriding procedure Finalize (This : in out Controlled_File) is
   begin
      if Ada.Text_IO.Is_Open (This.File) then
         Ada.Text_IO.Close (This.File);
      end if;
   end Finalize;
end RAII;
