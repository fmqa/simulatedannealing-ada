-- @summary
-- Simulated annealing metaheuristic library.
--
-- @description
-- This package provides routines for the minimization of black-box
-- functions using simulated annealing.
package Simulated_Annealing is
   -- Annealing scheduler.
   type Scheduler is private;

   function Exponential (N : Positive; T0 : Float) return Scheduler;
   -- Create a new exponential (geometric) annealing scheduler.
   -- @param N The number of cooling steps.
   -- @param T0 The starting temperature.
   -- @return The geometric annealing scheduler.

   procedure Step (S : in out Scheduler);
   -- Perform a cool-down step.
   -- @param S The annealing scheduler.

   function Temperature (S : in Scheduler) return Float;
   -- Return the current temperature.
   -- @param S The annealing scheduler.
   -- @return The annealing schedule's current temperature.

   -- @summary
   -- Simulated annealing minimizer.
   --
   -- @description
   -- Provides an implementation of a simulated annealing
   -- minimization algorithm.
   generic
      -- State type.
      type State is private;

      -- State energy function.
      with function Energy (S : in State) return Float;

      -- State perturbation function.
      with function Perturb (S : in out State) return State;
   package Optimization is
      -- Minimization progress record.
      type Minimization is private;

      function Minimize (S0 : in State) return Minimization;
      -- Create a new minimizer.
      -- @param S0 The initial state.
      -- @return The minimization progress record.

      function Step (M : in out Minimization; S : in out Scheduler;
         Improved      :    out Boolean) return Boolean;
   -- Perform a minimization iteration.
   -- @param M The minimization progress record.
   -- @param S The annealing scheduler to use.
   -- @param Improved True if a new local minimum was found, false otherwise.
   -- @return True if the annealing process is unfinished, false otherwise.

      function Minimum (M : in Minimization) return State;
      -- Return the best minimum found so far.
      -- @param M The minimization progress record.
      -- @return The best-so-far minimum state found.
   private
      type Minimization is record
         S_I   : State;
         S_Min : State;
      end record;
   end Optimization;
private
   type Scheduler is record
      T0    : Float;
      Decay : Float;
      I     : Natural;
   end record;
end Simulated_Annealing;
