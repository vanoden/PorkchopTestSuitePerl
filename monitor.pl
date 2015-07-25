###################################################
### Test Monitor Module							###
###################################################
# Load Monitor Module
require Porkchop::Monitor;
my $_monitor = Porkchop::Monitor->new({
	'hostname'	=> $config{hostname},
	'login'		=> $config{login},
	'password'	=> $config{password},
});
die "Failed to initialize Monitor module: ".$_monitor->{error}."\n " if ($_monitor->{error});

# Connect (authenticate)
$_monitor->connect();
die "Cannot connect to site: ".$_monitor->{error}."\n" if ($_monitor->{error});

# Create New Asset
my $asset = {
	"code"			=> "test_".time,
	"name"			=> $config{test_name},
	"organization"	=> $config{test_organization},
	"product"		=> $config{test_product}
};
print "\tAdding asset ".$asset->{code}."\n";
my $new_asset = $_monitor->addAsset($asset);
die "Error adding asset : ".$_monitor->{error}."\n" if ($_monitor->{error});

# Confirm Creation
my $fetched_asset = $_monitor->getAsset({
	"code"	=> $asset->{code}
});
die "Error getting asset: ".$_monitor->{error}."\n" if ($_monitor->{error});
die "Asset not found" unless ($fetched_asset->{id});

# Update Asset

# Confirm Changes

# Create Metadata
$_monitor->setCollectionMetadata({
	"code"	=> $found_collection->{code},
	"key"	=> $key,
	"value"	=> $collection->{$key}
});
if ($_monitor->{error})
{
	die "Cannot add collection metadata: ".$_monitor->{error}."\n";
}

# Add Sensors
my $sensors = [
	{
		"asset_code"	=> $asset->{code},
		"code"	=> "1",
		"units"	=> "ppm"
	},
	{
		"asset_code"	=> $asset->{code},
		"code"	=> "2",
		"units"	=> "ppm"
	}
];

foreach my $sensor (@{$sensors})
{
	$new_sensor = $_monitor->addSensor($sensor);
	die "Error adding sensor: ".$_monitor->{error}."\n" if ($_monitor->{error});
	
}

# Confirm Sensors Added
foreach my $sensor (@{$sensors})
{
	$fetched_sensor = $_monitor->getSensor($sensor);
	die "Error getting sensor: ".$_monitor->{error}."\n" if ($_monitor->{error});
}

# Add data
$_monitor->addReading({
		"asset_code"	=> $asset->{code},
		"sensor_code"	=> $sensor->{code},
		"organization"	=> $reading->{organization_id},
		"date_reading"	=> $reading->{date_reading},
		"value"			=> $reading->{value}
	}
);
# Confirm Data Present

# Create Collection
my $new_collection = $_monitor->addCollection({
	"code"				=> $collection->{code},
	"name"				=> $collection->{code},
	"organization_code"	=> $collection->{organization_id},
	"date_start"		=> $collection->{date_start},
	"date_end"			=> $collection->{date_end}
});
if ($_monitor->{error})
{
	die "Error adding collection: ".$_monitor->{error}."\n";
}

# Confirm Creation

# Update Collection
$found_collection = $_monitor->updateCollection({
	"code"				=> $collection->{code},
	"name"				=> $collection->{code},
	"organization_code"	=> $collection->{organization_id},
	"date_start"		=> $collection->{date_start},
	"date_end"			=> $collection->{date_end}
});
if ($_monitor->{error})
{
	warn "Error updating collection: ".$_monitor->{error}."\n";
	next;
}
# Confirm Updates

# Add Sensors to Collection
my $new_sensor = $_monitor->addCollectionSensor({
	"collection_code"	=> $collection->{code},
	"sensor_code"		=> $sensor->{sensor_code},
	"asset_code"		=> $sensor->{asset_code},
	"name"				=> $sensor->{name},
	}
);
if ($_monitor->{error})
{
	warn "Failed to add collection sensor: ".$_monitor->{error}."\n";
}

# Confirm Sensor Added
my $found_sensor = $_monitor->getCollectionSensor({
	"collection_code"	=> $collection->{code},
	"sensor_code"		=> $sensor->{sensor_code},
	"asset_code"		=> $sensor->{asset_code}
});
if ($found_sensor->{id})
{
	print "\t\tFound\n";
}

# Query Collection for Data

my @collection_metadata_keys = (
	"name",
	"location",
	"fumigant",
	"commodity",
	"customer",
	"temperature",
	"temp_units",
	"concentration",
	"conc_units"
);

1