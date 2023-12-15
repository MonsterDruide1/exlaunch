#pragma once

namespace exl::hook::nx64 {

    union GpRegister {
        u64 X;
        u32 W;
    };

    union GpRegisters {
        GpRegister m_Gp[32];
        struct {
            GpRegister _Gp[30];
            GpRegister m_Fp;
            GpRegister m_Lr;
        };
    };
    
    union FpRegister {
        f64 Q[2];
        //f128 Q;
        f64 D;
        f32 S;
        f16 H;
        //f8 B;
    };

    union FpRegisters {
        FpRegister m_Fps[32];
        // might add FPCRs here?
    };

    namespace impl {
        /* This type is only unioned with GpRegisters, so this is valid. */
        struct GpRegisterAccessorImpl {
            GpRegisters& Get() {
                return *reinterpret_cast<GpRegisters*>(this);
            }
        };

        struct GpRegisterAccessor64 : public GpRegisterAccessorImpl {
            u64& operator[](int index)
            {
                return Get().m_Gp[index].X;
            }
        };

        struct GpRegisterAccessor32 : public GpRegisterAccessorImpl {
            u32& operator[](int index)
            {
                return Get().m_Gp[index].W;
            }
        };

        
        struct FpRegisterAccessorImpl {
            FpRegisters& Get() {
                return *reinterpret_cast<FpRegisters*>(this);
            }
        };
        
        /*struct FpRegisterAccessor128 : public FpRegisterAccessorImpl {
            f128& operator[](int index)
            {
                return Get().m_Fps[index].V;
            }
        };*/
        struct FpRegisterAccessor64 : public FpRegisterAccessorImpl {
            f64& operator[](int index)
            {
                return Get().m_Fps[index].D;
            }
        };
        struct FpRegisterAccessor32 : public FpRegisterAccessorImpl {
            f32& operator[](int index)
            {
                return Get().m_Fps[index].S;
            }
        };
        struct FpRegisterAccessor16 : public FpRegisterAccessorImpl {
            f16& operator[](int index)
            {
                return Get().m_Fps[index].H;
            }
        };
        /*struct FpRegisterAccessor8 : public FpRegisterAccessorImpl {
            f8& operator[](int index)
            {
                return Get().m_Fps[index].B;
            }
        };*/
    }

    struct InlineCtx {
        union {
            /* Accessors are union'd with the gprs so that they can be accessed directly. */
            impl::GpRegisterAccessor64 X;
            impl::GpRegisterAccessor32 W;
            GpRegisters m_Gpr;
        };
        union {
            //impl::FpRegisterAccessor128 Q;
            impl::FpRegisterAccessor64 D;
            impl::FpRegisterAccessor32 S;
            impl::FpRegisterAccessor16 H;
            //impl::FpRegisterAccessor8 B;
            FpRegisters m_Fpr;
        };
    };

    void InitializeInline();
}
