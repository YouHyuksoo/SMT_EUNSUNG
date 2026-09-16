import { useEffect, useState } from "react";
import api from "@/services/api";
import type { ProductModelRow } from "./productModelColumns";

export function useProductModels() {
  const [data, setData] = useState<ProductModelRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [failed, setFailed] = useState(false);
  const [revision, setRevision] = useState(0);

  useEffect(() => {
    const controller = new AbortController();
    setLoading(true);
    setFailed(false);
    async function load() {
      try {
        const response = await api.get<{ data: { list: ProductModelRow[] } }>(
          "/master/product-models", { signal: controller.signal },
        );
        if (!Array.isArray(response.data?.data?.list)) throw new Error("Invalid model response");
        if (!controller.signal.aborted) setData(response.data.data.list);
      } catch (error: unknown) {
        if (!controller.signal.aborted) {
          setData([]);
          setFailed(true);
        }
      } finally {
        if (!controller.signal.aborted) setLoading(false);
      }
    }
    void load();
    return () => controller.abort();
  }, [revision]);

  return { data, loading, failed, refresh: () => setRevision(value => value + 1) };
}
