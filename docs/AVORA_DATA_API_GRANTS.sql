-- AVORA Stage 5: Data API grants
-- RLS/policies should remain enabled. These grants allow the authenticated
-- Flutter client to reach the tables; RLS still controls which rows are allowed.

grant select, insert, update, delete on public.profiles to authenticated;
grant select, insert, update, delete on public.vehicles to authenticated;
grant select, insert, update, delete on public.driver_profiles to authenticated;
grant select, insert, update, delete on public.addresses to authenticated;
grant select, insert, update, delete on public.orders to authenticated;
grant select, insert, update, delete on public.order_status_history to authenticated;
grant select, insert, update, delete on public.driver_locations to authenticated;
grant select on public.tariffs to authenticated;
grant select, insert, update, delete on public.payments to authenticated;
grant select, insert, update on public.notifications to authenticated;
grant select, insert, update, delete on public.proof_of_delivery to authenticated;
