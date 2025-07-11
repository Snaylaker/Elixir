defmodule Kv.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(KV.Registry)
    %{registry: registry}
  end

  test "spawn buckets", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error

    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes bucket on exit", %{registry: registry} do
    KV.Registry.create(registry, "shooping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shooping")
    Agent.stop(bucket)
    assert KV.Registry.lookup(registry, "shooping") == :error
  end
end
