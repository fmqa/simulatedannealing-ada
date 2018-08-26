with Ada.Finalization;
with Ada.Text_IO;

package RAII is
   type Controlled_File is new Ada.Finalization.Limited_Controlled with record
      File : Ada.Text_IO.File_Type;
   end record;

   overriding procedure Finalize (This : in out Controlled_File);
end RAII;
