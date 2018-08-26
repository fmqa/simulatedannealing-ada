with Ada.Text_IO;
with Ada.Float_Text_IO;
with Ada.Long_Integer_Text_IO;
with Ada.Command_Line;
with Ada.Environment_Variables;
with Bitmaps.IO;
with Bitmaps.RGB;
with Ada.Text_IO.Text_Streams;
with Problem;
with ImageOps;
with Simulated_Annealing;
with RAII;

procedure Main is
   package Positive_IO is new Ada.Text_IO.Integer_IO (Positive);

   type Image_Access is access all Bitmaps.RGB.Image;
   package Image_Problem is new Problem (Image_Access);

   function Opt_Iterations return Positive is
      Result : Positive := 1000000;
      Last   : Positive;
   begin
      if Ada.Environment_Variables.Exists ("ANNEALING_ITERATIONS") then
         Positive_IO.Get
           (From => Ada.Environment_Variables.Value ("ANNEALING_ITERATIONS"),
            Item => Result, Last => Last);
      end if;
      return Result;
   end Opt_Iterations;

   function Opt_Temperature return Float is
      Result : Float := 100.0;
      Last   : Positive;
   begin
      if Ada.Environment_Variables.Exists ("ANNEALING_TEMPERATURE") then
         Ada.Float_Text_IO.Get
           (From => Ada.Environment_Variables.Value ("ANNEALING_TEMPERATURE"),
            Item => Result, Last => Last);
      end if;
      return Result;
   end Opt_Temperature;

   function Opt_Size return Positive is
      Result : Positive := 64;
      Last : Positive;
   begin
      if Ada.Environment_Variables.Exists("ANNEALING_SIZE") then
         Positive_IO.Get
           (From => Ada.Environment_Variables.Value("ANNEALING_SIZE"),
            Item => Result, Last => Last);
      end if;
      return Result;
   end Opt_Size;

   Bitmap_Size : constant Positive := Opt_Size;

   B : aliased Bitmaps.RGB.Image (Bitmap_Size, Bitmap_Size);
   S : Image_Problem.State;
begin
   ImageOps.Noise (B);

   S.Img := B'Access;
   S.E   := ImageOps.Adj_Distance_Sum (B);
   Image_Problem.Roll (S);
   S.Visited := False;

   declare
      M     : Image_Problem.Opt.Minimization := Image_Problem.Opt.Minimize (S);
      Sched : Simulated_Annealing.Scheduler  :=
        Simulated_Annealing.Exponential (Opt_Iterations, Opt_Temperature);
      Improved : Boolean := False;
   begin
      while Image_Problem.Opt.Step (M, Sched, Improved) loop
         if Improved then
            Ada.Text_IO.Put ("T = ");
            Ada.Float_Text_IO.Put (Simulated_Annealing.Temperature (Sched));
            Ada.Text_IO.Put (", E = ");
            Ada.Long_Integer_Text_IO.Put
              (Image_Problem.Opt.Minimum (M).E, Width => 0);
            Ada.Text_IO.New_Line;

            if Ada.Command_Line.Argument_Count > 0 then
               declare
                  CF : RAII.Controlled_File;
               begin
                  Ada.Text_IO.Open
                    (CF.File, Ada.Text_IO.Out_File,
                     Ada.Command_Line.Argument (1));
                  Bitmaps.IO.Write_PPM_P6
                    (Ada.Text_IO.Text_Streams.Stream (CF.File), B);
               end;
            end if;
         end if;
      end loop;
   end;

end Main;
