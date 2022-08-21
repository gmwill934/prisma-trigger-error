create table shipment (
	client varchar(16) not null default(current_setting('app.client')::varchar(16)),
	warehouse varchar(16) not null default(current_setting('app.warehouse')::varchar(16)),
	id varchar(64) default(''),
	notes text null,
	is_validated boolean not null default(false),
	constraint "PK_Shipment__id" primary key (id)
);


create or replace function shipment_custom_id_generator() returns trigger as $$
begin
	new.id = (select
		   		current_setting('app.client') || current_setting('app.warehouse') || 'LPN' || LPAD(cast(count(*) + 1 as varchar(64)),8,'0')::varchar(16)
			from 
				shipment
			where
				client = current_setting('app.client')
				and warehouse = current_setting('app.warehouse')
		   );
	return new;
end
$$ language plpgsql

create trigger shipment_custom_generator_id_trigger
before insert on shipment
for each row
execute procedure shipment_custom_id_generator();
