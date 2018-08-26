with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Numerics.Float_Random;

package body Simulated_Annealing is
   package Value_Functions is new Ada.Numerics.Generic_Elementary_Functions
     (Float);
   use Value_Functions;

   EPSILON : constant Float := 0.001;

   Generator : Ada.Numerics.Float_Random.Generator;

   function Acceptable (E_Diff, Temperature : Float) return Boolean is
     (E_Diff < 0.0 or else
      Ada.Numerics.Float_Random.Random (Generator) <=
        Exp (-E_Diff / Temperature));

   function Exponential (N : Positive; T0 : Float) return Scheduler is
     (T0 => T0, Decay => Log (EPSILON / T0) / Float (N), I => 0);

   procedure Step (S : in out Scheduler) is
   begin
      S.I := S.I + 1;
   end Step;

   function Temperature (S : in Scheduler) return Float is
      TI : Float := S.T0 * Exp (S.Decay * Float (S.I));
   begin
      if TI < EPSILON then
         TI := 0.0;
      end if;
      return TI;
   end Temperature;

   package body Optimization is
      function Minimize (S0 : in State) return Minimization is
        (S_I => S0, S_Min => S0);

      function Step (M : in out Minimization; S : in out Scheduler;
         Improved      :    out Boolean) return Boolean
      is
         T : Float := Temperature (S);
      begin
         Improved := False;
         if T > 0.0 then
            declare
               S_J    : State := Perturb (M.S_I);
               E_Diff : Float := Energy (S_J) - Energy (M.S_I);
            begin
               if Acceptable (E_Diff, T) then
                  M.S_I := S_J;
                  if Energy (M.S_I) < Energy (M.S_Min) then
                     M.S_Min  := M.S_I;
                     Improved := True;
                  end if;
               end if;
               Step (S);
            end;
            return True;
         else
            return False;
         end if;
      end Step;

      function Minimum (M : in Minimization) return State is (M.S_Min);
   end Optimization;

end Simulated_Annealing;
